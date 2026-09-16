/**
 * FightDFear Universal CSRF Protection & Form Synchronization
 * Automatically ensures every POST form, multipart upload, fetch, and XMLHttpRequest
 * carries a valid CSRF token recognized by Spring Security.
 */
(function() {
    'use strict';

    if (window.__csrfSyncInitialized) return;
    window.__csrfSyncInitialized = true;

    function getCsrfCookie() {
        var match = document.cookie.match(new RegExp('(^|;\\s*)XSRF-TOKEN=([^;]*)'));
        return match ? decodeURIComponent(match[2]) : null;
    }

    function getCsrfToken() {
        // 1. XSRF-TOKEN Cookie
        var cookieToken = getCsrfCookie();
        if (cookieToken) return cookieToken;

        // 2. Meta tags
        var meta = document.querySelector('meta[name="_csrf"]');
        if (meta && meta.content) return meta.content;

        // 3. Global CSRF input
        var globalInput = document.getElementById('_global_csrf');
        if (globalInput && globalInput.value) return globalInput.value;

        // 4. Existing form inputs
        var inputs = document.querySelectorAll('input[name="_csrf"]');
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].value) return inputs[i].value;
        }

        return null;
    }

    function syncForm(form) {
        if (!form) return;
        var method = (form.method || 'GET').toUpperCase();
        if (method === 'GET') return;

        var token = getCsrfToken();
        if (!token) return;

        // Ensure hidden input exists
        var csrfInput = form.querySelector('input[name="_csrf"]');
        if (!csrfInput) {
            csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = '_csrf';
            csrfInput.value = token;
            form.appendChild(csrfInput);
        } else if (!csrfInput.value) {
            csrfInput.value = token;
        }

        // For multipart forms or query string fallback
        if (form.action && form.action !== '#' && !form.action.endsWith('#') && !form.action.includes('_csrf=')) {
            var sep = form.action.includes('?') ? '&' : '?';
            form.action += sep + '_csrf=' + encodeURIComponent(token);
        }
    }

    // Sync all existing forms when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('form').forEach(syncForm);
        });
    } else {
        document.querySelectorAll('form').forEach(syncForm);
    }

    // Capture submit events on dynamically created or existing forms
    document.addEventListener('submit', function(e) {
        if (e.target && e.target.tagName === 'FORM') {
            syncForm(e.target);
        }
    }, true);

    // Intercept programmatic form.submit() calls
    if (typeof HTMLFormElement !== 'undefined' && HTMLFormElement.prototype) {
        var originalSubmit = HTMLFormElement.prototype.submit;
        HTMLFormElement.prototype.submit = function() {
            try {
                syncForm(this);
            } catch (err) {
                console.warn('[CSRF] Failed to sync form before submit', err);
            }
            return originalSubmit.apply(this, arguments);
        };
    }

    // Intercept window.fetch to attach X-XSRF-TOKEN & X-CSRF-TOKEN headers for same-origin requests
    if (typeof window.fetch === 'function') {
        var originalFetch = window.fetch;
        window.fetch = function(input, init) {
            init = init || {};
            var method = (init.method || 'GET').toUpperCase();
            if (method !== 'GET' && method !== 'HEAD' && method !== 'OPTIONS') {
                var token = getCsrfToken();
                if (token) {
                    if (!init.headers) {
                        init.headers = {};
                    }
                    if (typeof Headers !== 'undefined' && init.headers instanceof Headers) {
                        init.headers.set('X-XSRF-TOKEN', token);
                        init.headers.set('X-CSRF-TOKEN', token);
                    } else if (Array.isArray(init.headers)) {
                        var hasHeader = init.headers.some(function(pair) {
                            return pair[0].toLowerCase() === 'x-xsrf-token' || pair[0].toLowerCase() === 'x-csrf-token';
                        });
                        if (!hasHeader) {
                            init.headers.push(['X-XSRF-TOKEN', token]);
                            init.headers.push(['X-CSRF-TOKEN', token]);
                        }
                    } else if (typeof init.headers === 'object') {
                        init.headers['X-XSRF-TOKEN'] = token;
                        init.headers['X-CSRF-TOKEN'] = token;
                    }
                }
            }
            return originalFetch.call(this, input, init);
        };
    }

    // Intercept XMLHttpRequest to attach X-XSRF-TOKEN & X-CSRF-TOKEN
    if (typeof XMLHttpRequest !== 'undefined' && XMLHttpRequest.prototype) {
        var originalOpen = XMLHttpRequest.prototype.open;
        var originalSend = XMLHttpRequest.prototype.send;

        XMLHttpRequest.prototype.open = function(method, url) {
            this._csrfMethod = (method || 'GET').toUpperCase();
            return originalOpen.apply(this, arguments);
        };

        XMLHttpRequest.prototype.send = function() {
            if (this._csrfMethod && this._csrfMethod !== 'GET' && this._csrfMethod !== 'HEAD') {
                var token = getCsrfToken();
                if (token) {
                    try {
                        this.setRequestHeader('X-XSRF-TOKEN', token);
                        this.setRequestHeader('X-CSRF-TOKEN', token);
                    } catch (e) {}
                }
            }
            return originalSend.apply(this, arguments);
        };
    }
})();
