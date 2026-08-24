<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Complete Purchase — Fight D Fear</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&family=Montserrat:wght@700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fightdfire-theme.css">
  <style>
    *, *::before, *::after {
      box-sizing: border-box;
    }
    body {
      font-family: 'Poppins', sans-serif;
      background: #fffcfd;
      color: var(--fdf-text);
      min-height: 100vh;
      padding: 40px 20px;
    }
    .checkout-wrapper {
      max-width: 1000px;
      margin: 0 auto;
    }
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      color: var(--brand-purple);
      text-decoration: none;
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 30px;
      transition: all 0.3s ease;
      padding: 8px 16px;
      background: #fff;
      border-radius: 999px;
      border: 1px solid var(--fdf-border);
      box-shadow: var(--shadow-sm);
    }
    .back-link:hover {
      background: var(--brand-purple);
      color: #fff;
      transform: translateX(-5px);
    }
    .page-title {
      font-family: 'Montserrat', sans-serif;
      font-size: 32px;
      font-weight: 900;
      color: var(--brand-purple-darker);
      margin-bottom: 30px;
    }

    .checkout-grid {
      display: grid;
      grid-template-columns: 1.5fr 1fr;
      gap: 30px;
    }

    .checkout-card {
      background: #fff;
      border: 1px solid var(--fdf-border);
      border-radius: 24px;
      padding: 30px;
      box-shadow: var(--shadow-sm);
      margin-bottom: 24px;
    }
    .card-title {
      font-size: 18px;
      font-weight: 800;
      color: var(--brand-purple);
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .card-title i { color: var(--brand-pink); }

    .fdf-form-group {
      margin-bottom: 20px;
    }
    .fdf-form-group label {
      display: block;
      font-size: 13px;
      font-weight: 700;
      color: var(--fdf-muted);
      margin-bottom: 8px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .fdf-input {
      width: 100%;
      padding: 14px 18px;
      background: #fdf2f8;
      border: 1px solid transparent;
      border-radius: 14px;
      font-size: 15px;
      font-family: 'Poppins', sans-serif;
      transition: all 0.3s;
      outline: none;
    }
    .fdf-input:focus {
      border-color: var(--brand-pink-light);
      background: #fff;
      box-shadow: 0 0 0 4px rgba(219, 39, 119, 0.05);
    }

    .payment-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }
    .pay-option {
      padding: 24px 16px;
      border: 2px solid #f3f4f6;
      border-radius: 18px;
      cursor: pointer;
      text-align: center;
      transition: all 0.3s;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 10px;
    }
    .pay-option:hover {
      border-color: var(--brand-pink-light);
      background: #fff5f7;
    }
    .pay-option.selected {
      border-color: var(--brand-pink);
      background: #fdf2f8;
      box-shadow: 0 10px 20px rgba(219, 39, 119, 0.05);
    }
    .pay-option i {
      font-size: 28px;
      color: var(--brand-purple);
    }
    .pay-option.selected i { color: var(--brand-pink); }
    .pay-option span { font-size: 14px; font-weight: 700; color: var(--brand-purple-dark); }

    .summary-item {
      display: flex;
      gap: 16px;
      padding: 16px 0;
      border-bottom: 1px solid #f3f4f6;
    }
    .summary-item:last-child { border: none; }
    .summary-item img {
      width: 60px;
      height: 60px;
      border-radius: 12px;
      object-fit: cover;
    }
    .summary-item .info { flex: 1; }
    .summary-item .name { font-size: 14px; font-weight: 700; color: var(--brand-purple-dark); }
    .summary-item .qty { font-size: 12px; color: var(--fdf-muted); margin-top: 2px; }
    .summary-item .price { font-size: 15px; font-weight: 800; color: var(--brand-purple); }

    .total-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 20px;
      border-top: 2px solid var(--fdf-border);
      margin-top: 10px;
    }
    .total-label { font-size: 16px; font-weight: 700; color: var(--fdf-muted); }
    .total-val { font-size: 24px; font-weight: 900; color: var(--brand-purple-darker); }

    .btn-place-order {
      width: 100%;
      padding: 20px;
      background: var(--gradient-primary);
      color: #fff;
      border: none;
      border-radius: 18px;
      font-size: 18px;
      font-weight: 800;
      margin-top: 30px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      transition: all 0.3s;
      box-shadow: 0 12px 24px rgba(124, 45, 94, 0.2);
    }
    .btn-place-order:hover {
      transform: translateY(-4px);
      box-shadow: 0 18px 36px rgba(124, 45, 94, 0.3);
      filter: brightness(1.1);
    }

    @media (max-width: 850px) {
      .checkout-grid { grid-template-columns: 1fr; }
    }

    /* Address Styles */
    .address-card {
      border: 1px solid var(--fdf-border);
      border-radius: 12px;
      padding: 16px;
      margin-bottom: 12px;
      cursor: pointer;
      position: relative;
      transition: all 0.2s;
      background: #fcfcfc;
    }
    .address-card.selected {
      border-color: var(--brand-pink);
      background: #fdf2f8;
    }
    .address-card:hover {
      border-color: var(--brand-purple);
    }
    .addr-actions {
      position: absolute;
      top: 16px;
      right: 16px;
    }
    .addr-btn {
      background: none;
      border: none;
      color: var(--brand-purple);
      cursor: pointer;
      font-size: 14px;
      padding: 4px;
    }
    .addr-btn:hover { color: var(--brand-pink); }
    
    .btn-add-new {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: #fdf2f8;
      color: var(--brand-pink);
      border: 1px dashed var(--brand-pink);
      padding: 6px 12px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 700;
      cursor: pointer;
    }
    .btn-add-new:hover {
      background: #fce7f3;
    }
    
    /* Online Payment Sub-menu */
    .online-pay-menu {
      display: none;
      margin-top: 16px;
      grid-column: span 2;
      background: #fafafa;
      border-radius: 12px;
      padding: 16px;
      gap: 10px;
      border: 1px solid #eee;
    }
    .online-pay-menu.active {
      display: flex;
      flex-direction: column;
    }
    .pay-radio {
      display: flex;
      align-items: center;
      gap: 10px;
      cursor: pointer;
      padding: 8px;
      border-radius: 8px;
      transition: background 0.2s;
    }
    .pay-radio:hover { background: #f0f0f0; }
    .pay-radio input { accent-color: var(--brand-pink); width: 16px; height: 16px; cursor: pointer; }
    .pay-radio span { font-weight: 600; color: #333; font-size: 14px; }
    
    /* Modal Styles */
    .fdf-modal-overlay {
      position: fixed; top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 1000;
      display: none;
      align-items: center;
      justify-content: center;
    }
    .fdf-modal-overlay.active { display: flex; }
    .fdf-modal {
      background: #fff;
      border-radius: 20px;
      width: 90%;
      max-width: 500px;
      padding: 24px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.2);
    }
    .modal-header {
      display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
    }
    .modal-title { font-size: 18px; font-weight: 800; color: var(--brand-purple); }
    .close-modal { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
    .form-row { display: flex; gap: 16px; }
    .form-row .fdf-form-group { flex: 1; }
  </style>
</head>
<body>
  <div class="checkout-wrapper">
    <a href="${pageContext.request.contextPath}/women-products/cart" class="back-link">
      <i class="bi bi-arrow-left"></i> My Collection
    </a>
    
    <div class="page-title">Shopping Checkout</div>

    <form method="post" action="${pageContext.request.contextPath}/women-products/checkout/place" id="checkoutForm">
      <div class="checkout-grid">
        <!-- Left Column: Details -->
        <div class="details-column">
          <div class="checkout-card">
            <div class="card-title" style="display:flex; justify-content:space-between; width:100%;">
              <div><i class="bi bi-geo-alt-fill"></i> Delivery Destination</div>
              <button type="button" class="btn-add-new" onclick="openAddressModal()"><i class="bi bi-plus-lg"></i> Add New</button>
            </div>
            
            <div id="addressesList">
              <!-- Rendered via JS -->
            </div>
            <input type="hidden" name="shippingAddress" id="finalShippingAddress" required>
          </div>

          <div class="checkout-card">
            <div class="card-title"><i class="bi bi-shield-check"></i> Secure Payment</div>
            <div class="payment-grid">
              <div class="pay-option selected" onclick="selectPayment(this, 'COD')">
                <i class="bi bi-truck-flatbed"></i>
                <span>Cash on Delivery</span>
              </div>
              <div class="pay-option" onclick="selectPayment(this, 'ONLINE')">
                <i class="bi bi-lightning-charge-fill"></i>
                <span>Online Payment</span>
              </div>
              
              <div class="online-pay-menu" id="onlinePayMenu">
                <label class="pay-radio">
                  <input type="radio" name="onlineType" value="ONLINE_GPAY" checked onchange="updateOnlineMethod(this)">
                  <span><img src="https://upload.wikimedia.org/wikipedia/commons/f/f2/Google_Pay_Logo.svg" height="16" alt="GPay" style="margin-right:8px; vertical-align:middle;"> Google Pay</span>
                </label>
                <label class="pay-radio">
                  <input type="radio" name="onlineType" value="ONLINE_PHONEPE" onchange="updateOnlineMethod(this)">
                  <span><img src="https://upload.wikimedia.org/wikipedia/commons/7/71/PhonePe_Logo.svg" height="16" alt="PhonePe" style="margin-right:8px; vertical-align:middle;"> PhonePe</span>
                </label>
                <label class="pay-radio">
                  <input type="radio" name="onlineType" value="ONLINE_PAYTM" onchange="updateOnlineMethod(this)">
                  <span><img src="https://upload.wikimedia.org/wikipedia/commons/2/24/Paytm_Logo_%28standalone%29.svg" height="16" alt="Paytm" style="margin-right:8px; vertical-align:middle;"> Paytm</span>
                </label>
              </div>
            </div>
            <input type="hidden" name="paymentMethod" id="paymentMethod" value="COD">
          </div>
        </div>

        <!-- Right Column: Summary -->
        <div class="summary-column">
          <div class="checkout-card">
            <div class="card-title"><i class="bi bi-bag-check-fill"></i> Collection Summary</div>
            <div class="summary-list">
              <c:forEach var="ci" items="${cartItems}">
                <div class="summary-item">
                  <c:choose>
                    <c:when test="${not empty ci.product.imagePath}">
                      <img src="${pageContext.request.contextPath}${ci.product.imagePath}" alt="${ci.product.name}">
                    </c:when>
                    <c:otherwise>
                      <div class="placeholder"><i class="bi bi-gift"></i></div>
                    </c:otherwise>
                  </c:choose>
                  <div class="info">
                    <div class="name">${ci.product.name}</div>
                    <div class="qty">Selected: ${ci.quantity}</div>
                  </div>
                  <div class="price">&#8377;${ci.product.price * ci.quantity}</div>
                </div>
              </c:forEach>
            </div>

            <div class="total-row">
              <span class="total-label">Total to Pay</span>
              <span class="total-val">&#8377;${cartTotal}</span>
            </div>

            <button type="submit" class="btn-place-order">
              Complete Order <i class="bi bi-arrow-right-circle-fill"></i>
            </button>
          </div>
          
          <p style="text-align: center; color: var(--fdf-muted); font-size: 12px; padding: 0 20px;">
            <i class="bi bi-lock-fill"></i> Your transaction is secure and encrypted.
          </p>
        </div>
      </div>
    </form>
  </div>

  <!-- Address Modal -->
  <div class="fdf-modal-overlay" id="addrModal">
    <div class="fdf-modal">
      <div class="modal-header">
        <div class="modal-title" id="modalTitle">Add New Address</div>
        <button type="button" class="close-modal" onclick="closeAddressModal()">&times;</button>
      </div>
      <input type="hidden" id="editAddrId" value="">
      
      <div class="form-row">
        <div class="fdf-form-group">
          <label>Flat No / Building</label>
          <input type="text" id="addrFlat" class="fdf-input" placeholder="e.g. Flat 101">
        </div>
        <div class="fdf-form-group">
          <label>Pincode</label>
          <input type="text" id="addrPin" class="fdf-input" placeholder="e.g. 560001" maxlength="6" oninput="this.value=this.value.replace(/[^0-9]/g,'')">
        </div>
      </div>
      <div class="fdf-form-group">
        <label>House Name (Optional)</label>
        <input type="text" id="addrHouse" class="fdf-input" placeholder="e.g. Rose Villa">
      </div>
      <div class="fdf-form-group">
        <label>Full Address / Area</label>
        <textarea id="addrFull" class="fdf-input" rows="2" placeholder="e.g. 12th Main, Indiranagar, Bangalore"></textarea>
      </div>
      <div class="fdf-form-group">
        <label>Landmark</label>
        <input type="text" id="addrLandmark" class="fdf-input" placeholder="e.g. Near City Park">
      </div>
      
      <button type="button" class="btn-place-order" style="margin-top: 10px; padding: 14px;" onclick="saveAddress()">Save Address</button>
    </div>
  </div>

  <script>
    // --- Address Logic ---
    let addresses = JSON.parse(localStorage.getItem('fdf_user_addresses')) || [];
    let selectedAddrId = null;

    function renderAddresses() {
      const container = document.getElementById('addressesList');
      if (addresses.length === 0) {
        container.innerHTML = '<div style="text-align:center; padding: 20px; color: #999; font-size:13px; background:#f9f9f9; border-radius:12px;">No addresses found. Please add a delivery destination.</div>';
        document.getElementById('finalShippingAddress').value = "";
        return;
      }
      
      let html = '';
      addresses.forEach(addr => {
        const isSelected = addr.id === selectedAddrId ? 'selected' : '';
        html += `
          <div class="address-card \${isSelected}" onclick="selectAddress(\${addr.id})">
            <div class="addr-actions">
              <button type="button" class="addr-btn" onclick="event.stopPropagation(); editAddress(\${addr.id})"><i class="bi bi-pencil-square"></i></button>
              <button type="button" class="addr-btn" style="color:#ef4444;" onclick="event.stopPropagation(); deleteAddress(\${addr.id})"><i class="bi bi-trash3"></i></button>
            </div>
            <div style="font-weight: 700; font-size:14px; margin-bottom:4px; padding-right:50px;">\${addr.flat}, \${addr.house ? addr.house + ',' : ''}</div>
            <div style="font-size:13px; color:#444; margin-bottom:4px; line-height: 1.4;">\${addr.full ? addr.full : ''}</div>
            <div style="font-size:12px; color:#666; margin-bottom:2px;">Landmark: \${addr.landmark}</div>
            <div style="font-size:13px; font-weight:600; color:var(--brand-purple);">Pincode: \${addr.pin}</div>
          </div>
        `;
      });
      container.innerHTML = html;
      
      if (!selectedAddrId && addresses.length > 0) {
        selectAddress(addresses[0].id);
      } else if (selectedAddrId) {
        updateHiddenAddress();
      }
    }

    function selectAddress(id) {
      selectedAddrId = id;
      renderAddresses();
      updateHiddenAddress();
    }

    function updateHiddenAddress() {
      const addr = addresses.find(a => a.id === selectedAddrId);
      if (addr) {
        let fullAddr = `Flat: \${addr.flat}, `;
        if (addr.house) fullAddr += `House: \${addr.house}, `;
        if (addr.full) fullAddr += `Address: \${addr.full}, `;
        fullAddr += `Landmark: \${addr.landmark}, Pincode: \${addr.pin}`;
        document.getElementById('finalShippingAddress').value = fullAddr;
      } else {
        document.getElementById('finalShippingAddress').value = "";
      }
    }

    function openAddressModal() {
      document.getElementById('modalTitle').innerText = "Add New Address";
      document.getElementById('editAddrId').value = "";
      document.getElementById('addrFlat').value = "";
      document.getElementById('addrPin').value = "";
      document.getElementById('addrHouse').value = "";
      document.getElementById('addrFull').value = "";
      document.getElementById('addrLandmark').value = "";
      document.getElementById('addrModal').classList.add('active');
    }

    function closeAddressModal() {
      document.getElementById('addrModal').classList.remove('active');
    }

    function saveAddress() {
      const flat = document.getElementById('addrFlat').value.trim();
      const pin = document.getElementById('addrPin').value.trim();
      const house = document.getElementById('addrHouse').value.trim();
      const full = document.getElementById('addrFull').value.trim();
      const landmark = document.getElementById('addrLandmark').value.trim();
      const idStr = document.getElementById('editAddrId').value;
      
      if (!flat || !pin || !landmark || !full) {
        alert("Please fill in Flat No, Full Address, Pincode, and Landmark.");
        return;
      }
      
      const fakePincodes = ['111111', '222222', '333333', '444444', '555555', '666666', '777777', '888888', '999999', '123456', '654321'];
      if (!/^[1-8]\d{5}$/.test(pin) || fakePincodes.includes(pin)) {
        alert("Please enter a valid 6-digit pincode.");
        return;
      }
      
      if (idStr) {
        const id = parseInt(idStr);
        const idx = addresses.findIndex(a => a.id === id);
        if (idx !== -1) {
          addresses[idx] = { id, flat, pin, house, full, landmark };
        }
      } else {
        const newId = Date.now();
        addresses.push({ id: newId, flat, pin, house, full, landmark });
        selectedAddrId = newId;
      }
      
      localStorage.setItem('fdf_user_addresses', JSON.stringify(addresses));
      closeAddressModal();
      renderAddresses();
    }

    function editAddress(id) {
      const addr = addresses.find(a => a.id === id);
      if (addr) {
        document.getElementById('modalTitle').innerText = "Edit Address";
        document.getElementById('editAddrId').value = addr.id;
        document.getElementById('addrFlat').value = addr.flat;
        document.getElementById('addrPin').value = addr.pin;
        document.getElementById('addrHouse').value = addr.house;
        document.getElementById('addrFull').value = addr.full || '';
        document.getElementById('addrLandmark').value = addr.landmark;
        document.getElementById('addrModal').classList.add('active');
      }
    }

    function deleteAddress(id) {
      if(confirm("Are you sure you want to delete this address?")) {
        addresses = addresses.filter(a => a.id !== id);
        if (selectedAddrId === id) selectedAddrId = null;
        localStorage.setItem('fdf_user_addresses', JSON.stringify(addresses));
        renderAddresses();
      }
    }

    // --- Payment Logic ---
    function selectPayment(el, method) {
      document.querySelectorAll('.pay-option').forEach(function(o){ o.classList.remove('selected'); });
      el.classList.add('selected');
      
      const menu = document.getElementById('onlinePayMenu');
      if (method === 'ONLINE') {
        menu.classList.add('active');
        const activeRadio = document.querySelector('input[name="onlineType"]:checked');
        if (activeRadio) {
          document.getElementById('paymentMethod').value = activeRadio.value;
        }
      } else {
        menu.classList.remove('active');
        document.getElementById('paymentMethod').value = method;
      }
    }
    
    function updateOnlineMethod(radioEl) {
      document.getElementById('paymentMethod').value = radioEl.value;
    }

    document.getElementById('checkoutForm').addEventListener('submit', function(e) {
      if (!document.getElementById('finalShippingAddress').value) {
        e.preventDefault();
        alert("Please select or add a delivery address.");
      }
    });

    window.onload = function() {
      const rawHome = "${user.homeAddress}";
      if (addresses.length === 0 && rawHome && rawHome.trim() !== '') {
         addresses.push({ id: Date.now(), flat: "Home Address", pin: "N/A", house: "", full: rawHome.trim(), landmark: "" });
         selectedAddrId = addresses[0].id;
         localStorage.setItem('fdf_user_addresses', JSON.stringify(addresses));
      }
      renderAddresses();
    };
  </script>
</body>
</html>


