"use client"; // บรรทัดที่สำคัญที่สุดเพื่อป้องกันบัคปุ่มกดไม่ทำงาน

import React, { useState, useEffect, useMemo } from 'react';

/**
 * 👑 LOVESHOP ULTIMATE PURPLE EDITION (ENTERPRISE)
 * Admin PIN: 123456
 * Theme: Deep Purple & Slate
 */

export default function LoveShopUltimate() {
  // ---------------------------------------------------------
  // 1. DATABASE STATE (จำลองฐานข้อมูลระดับสูง)
  // ---------------------------------------------------------
  const [categories, setCategories] = useState([
    { id: 1, name: "PREMIUM APPS", icon: "📺", desc: "แอปพลิเคชันความบันเทิง" },
    { id: 2, name: "GAMING TOPUP", icon: "💎", desc: "เติมเกมออนไลน์ทุกระบบ" },
    { id: 3, name: "GIFT CARDS", icon: "💳", desc: "บัตรเติมเงินต่างประเทศ" }
  ]);

  const [products, setProducts] = useState([
    { id: 101, catId: 1, name: "Netflix Premium 4K", price: 149, stock: 10, img: "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=500" },
    { id: 102, catId: 1, name: "YouTube No Ads", price: 59, stock: 99, img: "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=500" },
    { id: 201, catId: 2, name: "Valorant 1200 VP", price: 320, stock: 50, img: "https://images.unsplash.com/photo-1624138784614-87fd1b6528f8?w=500" },
    { id: 301, catId: 3, name: "iTunes $10 Card", price: 350, stock: 5, img: "https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=500" }
  ]);

  // ---------------------------------------------------------
  // 2. SYSTEM STATE (ระบบควบคุมหน้าและผู้ใช้)
  // ---------------------------------------------------------
  const [currentPage, setCurrentPage] = useState('home'); 
  const [activeCat, setActiveCat] = useState(null);
  const [isAdmin, setIsAdmin] = useState(false);
  const [pin, setPin] = useState("");
  const [user, setUser] = useState({
    username: "Premium_User_01",
    balance: 9850,
    history: []
  });

  // ---------------------------------------------------------
  // 3. CORE BUSINESS LOGIC (ตรรกะการทำงานห้ามบัค)
  // ---------------------------------------------------------
  
  // กรองสินค้าตามหมวดหมู่แบบเสถียร
  const filteredProducts = useMemo(() => {
    return activeCat ? products.filter(p => p.catId === activeCat) : products;
  }, [activeCat, products]);

  // ระบบเข้าหลังบ้าน (PIN Logic)
  const handleAdminAuth = () => {
    if (pin === "123456") {
      setIsAdmin(true);
      setCurrentPage('admin_dashboard');
      setPin("");
    } else {
      alert("❌ รหัสผ่านผิดพลาด! กรุณาลองใหม่");
      setPin("");
    }
  };

  // ระบบสั่งซื้อสินค้า (Transaction Logic)
  const buyProduct = (product) => {
    if (user.balance < product.price) return alert("❌ ยอดเงินไม่เพียงพอ!");
    if (product.stock <= 0) return alert("❌ สินค้าหมดสต็อก!");

    const orderId = "#LS-" + Math.random().toString(36).substr(2, 7).toUpperCase();
    
    // หักเงินและเพิ่มประวัติ
    setUser(prev => ({
      ...prev,
      balance: prev.balance - product.price,
      history: [{
        id: orderId,
        name: product.name,
        price: product.price,
        time: new Date().toLocaleString()
      }, ...prev.history]
    }));

    // ตัดสต็อก
    setProducts(prev => prev.map(p => p.id === product.id ? { ...p, stock: p.stock - 1 } : p));
    
    alert(`✅ ซื้อสำเร็จ!\nรายการ: ${product.name}\nรหัสอ้างอิง: ${orderId}`);
  };

  // ---------------------------------------------------------
  // 4. UI COMPONENTS (RENDER ENGINE)
  // ---------------------------------------------------------

  return (
    <div className="min-h-screen bg-[#020205] text-slate-200 font-sans selection:bg-purple-600">
      
      {/* 🚀 NAVIGATION BAR (Premium Blur) */}
      <nav className="sticky top-0 z-[100] bg-[#05050a]/80 backdrop-blur-xl border-b border-purple-500/10 px-6 py-4 flex justify-between items-center shadow-2xl">
        <div className="flex items-center gap-10">
          <div className="text-2xl font-black italic tracking-tighter cursor-pointer group" onClick={() => setCurrentPage('home')}>
            LOVE<span className="text-purple-500 group-hover:text-white transition-colors">SHOP</span>
          </div>
          <div className="hidden md:flex gap-8 text-[10px] font-black uppercase tracking-[0.2em] text-slate-500">
            <button onClick={() => setCurrentPage('home')} className="hover:text-purple-400 transition-all">Storefront</button>
            <button onClick={() => setCurrentPage('profile')} className="hover:text-purple-400 transition-all">My Orders</button>
          </div>
        </div>

        <div className="flex items-center gap-4">
          <div className="bg-purple-600/5 border border-purple-500/20 px-5 py-2 rounded-2xl flex flex-col items-end">
            <span className="text-[8px] font-black text-purple-500 uppercase leading-none mb-1">Balance</span>
            <span className="text-lg font-black text-white">{user.balance.toLocaleString()} <span className="text-xs text-purple-400">฿</span></span>
          </div>
          <button 
            onClick={() => isAdmin ? setCurrentPage('admin_dashboard') : setCurrentPage('admin_login')}
            className={`w-12 h-12 rounded-2xl flex items-center justify-center transition-all ${isAdmin ? 'bg-purple-600 shadow-[0_0_20px_rgba(147,51,234,0.5)]' : 'bg-slate-900 border border-slate-800 hover:border-purple-500/50'}`}
          >
            {isAdmin ? '⚙️' : '🔒'}
          </button>
        </div>
      </nav>

      <div className="max-w-7xl mx-auto p-6 md:p-10">
        
        {/* --- PAGE: HOME --- */}
        {currentPage === 'home' && (
          <div className="space-y-12">
            {/* Hero Section */}
            <div className="relative rounded-[3rem] overflow-hidden p-12 bg-gradient-to-br from-purple-900/20 to-transparent border border-purple-500/10">
              <div className="relative z-10 space-y-4 max-w-2xl">
                <h2 className="text-5xl md:text-7xl font-black italic tracking-tighter leading-none">THE ULTIMATE<br/><span className="text-purple-500">EXPERIENCE</span></h2>
                <p className="text-slate-500 font-bold uppercase tracking-widest text-xs">ระบบขายสินค้าดิจิทัลที่เร็วและเสถียรที่สุดในโลก</p>
                <div className="pt-6">
                  <button onClick={() => {setActiveCat(null); window.scrollTo({top: 800, behavior: 'smooth'})}} className="bg-purple-600 hover:bg-purple-700 text-white px-10 py-4 rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-purple-600/20 transition-all active:scale-95">Explore Store</button>
                </div>
              </div>
              <div className="absolute top-[-20%] right-[-10%] w-[500px] h-[500px] bg-purple-600/10 blur-[120px] rounded-full"></div>
            </div>

            {/* Shop Interface */}
            <div className="flex flex-col lg:flex-row gap-10">
              <aside className="w-full lg:w-72 space-y-3">
                <p className="text-[10px] font-black text-slate-600 uppercase tracking-widest mb-4">Categories</p>
                <button onClick={() => setActiveCat(null)} className={`w-full text-left p-4 rounded-2xl font-bold transition-all ${!activeCat ? 'bg-purple-600 shadow-lg shadow-purple-600/20' : 'bg-slate-900/50 hover:bg-slate-900'}`}>All Items</button>
                {categories.map(cat => (
                  <button key={cat.id} onClick={() => setActiveCat(cat.id)} className={`w-full text-left p-4 rounded-2xl font-bold transition-all ${activeCat === cat.id ? 'bg-purple-600 shadow-lg shadow-purple-600/20' : 'bg-slate-900/50 hover:bg-slate-900'}`}>
                    {cat.icon} <span className="ml-2">{cat.name}</span>
                  </button>
                ))}
              </aside>

              <div className="flex-grow grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                {filteredProducts.map(p => (
                  <div key={p.id} className="bg-slate-900/30 border border-slate-800 rounded-[2.5rem] overflow-hidden group hover:border-purple-500/40 transition-all duration-500">
                    <div className="h-48 overflow-hidden relative">
                      <img src={p.img} className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-1000" alt={p.name} />
                      <div className="absolute top-4 left-4 bg-black/60 backdrop-blur-md border border-white/10 px-3 py-1 rounded-full text-[10px] font-black uppercase text-purple-400">Stock: {p.stock}</div>
                    </div>
                    <div className="p-8 space-y-6">
                      <div>
                        <h3 className="text-xl font-black italic uppercase tracking-tight">{p.name}</h3>
                        <p className="text-slate-600 text-[10px] font-bold uppercase mt-1 tracking-widest">{categories.find(c => c.id === p.catId)?.name}</p>
                      </div>
                      <div className="flex justify-between items-center">
                        <span className="text-2xl font-black text-white">{p.price} ฿</span>
                        <button onClick={() => buyProduct(p)} className="bg-white text-black px-6 py-2.5 rounded-xl font-black text-[10px] uppercase hover:bg-purple-600 hover:text-white transition-all active:scale-90">Purchase</button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* --- PAGE: PROFILE & HISTORY --- */}
        {currentPage === 'profile' && (
          <div className="max-w-4xl mx-auto space-y-8">
            <div className="bg-slate-900/50 border border-slate-800 p-10 rounded-[3rem] flex flex-col md:flex-row justify-between items-center gap-6">
              <div className="flex items-center gap-6">
                <div className="w-20 h-20 rounded-full bg-gradient-to-tr from-purple-600 to-purple-400 flex items-center justify-center text-3xl font-black text-white shadow-xl shadow-purple-600/20">U</div>
                <div>
                  <h2 className="text-3xl font-black italic uppercase">{user.username}</h2>
                  <p className="text-purple-500 font-bold text-xs uppercase tracking-widest">Verified Member</p>
                </div>
              </div>
              <div className="text-center md:text-right">
                <p className="text-[10px] text-slate-500 font-black uppercase mb-1">Total Spent</p>
                <p className="text-4xl font-black">{user.history.reduce((sum, h) => sum + h.price, 0).toLocaleString()} <span className="text-sm text-purple-500">฿</span></p>
              </div>
            </div>

            <div className="bg-slate-900/20 border border-slate-800 rounded-[2.5rem] p-8">
              <h3 className="text-xl font-black italic uppercase border-l-4 border-purple-600 pl-4 mb-8">Recent Transactions</h3>
              <div className="space-y-4">
                {user.history.map(h => (
                  <div key={h.id} className="flex justify-between items-center p-6 bg-slate-900/50 border border-slate-800 rounded-2xl hover:bg-slate-900 transition-colors group">
                    <div className="space-y-1">
                      <p className="text-[10px] font-black text-purple-500">{h.id}</p>
                      <p className="font-bold uppercase text-sm group-hover:text-white transition-colors">{h.name}</p>
                      <p className="text-[10px] text-slate-600 font-bold uppercase">{h.time}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xl font-black text-white">-{h.price} ฿</p>
                      <span className="text-[9px] bg-green-500/10 text-green-500 px-3 py-1 rounded-full font-black uppercase">Completed</span>
                    </div>
                  </div>
                ))}
                {user.history.length === 0 && <div className="py-20 text-center text-slate-600 uppercase font-black tracking-widest italic">No orders found</div>}
              </div>
            </div>
          </div>
        )}

        {/* --- PAGE: ADMIN LOGIN (PIN PAD) --- */}
        {currentPage === 'admin_login' && (
          <div className="max-w-md mx-auto py-20 text-center">
            <h2 className="text-4xl font-black italic uppercase mb-2">Staff <span className="text-purple-500">Access</span></h2>
            <p className="text-slate-500 text-[10px] font-bold uppercase tracking-[0.4em] mb-12">Enter 6-Digit Secure PIN</p>
            
            <div className="flex justify-center gap-4 mb-12">
              {[...Array(6)].map((_, i) => (
                <div key={i} className={`w-12 h-16 rounded-2xl border-2 flex items-center justify-center text-2xl font-black transition-all ${pin[i] ? 'border-purple-600 bg-purple-600/10 shadow-[0_0_15px_rgba(147,51,234,0.3)]' : 'border-slate-800 bg-slate-900/50'}`}>
                  {pin[i] ? '●' : ''}
                </div>
              ))}
            </div>

            <div className="grid grid-cols-3 gap-4 max-w-[320px] mx-auto">
              {[1, 2, 3, 4, 5, 6, 7, 8, 9, 'C', 0, 'GO'].map(key => (
                <button 
                  key={key}
                  onClick={() => {
                    if (key === 'C') setPin("");
                    else if (key === 'GO') handleAdminAuth();
                    else if (pin.length < 6) setPin(p => p + key);
                  }}
                  className={`h-16 rounded-2xl font-black text-xl transition-all active:scale-90 ${key === 'GO' ? 'bg-purple-600 hover:bg-purple-700 shadow-lg shadow-purple-600/30' : 'bg-slate-900 hover:bg-slate-800'}`}
                >
                  {key}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* --- PAGE: ADMIN DASHBOARD (MASTER CONTROL) --- */}
        {currentPage === 'admin_dashboard' && isAdmin && (
          <div className="space-y-10">
            <div className="bg-purple-600/10 border border-purple-500/20 p-10 rounded-[3rem] flex justify-between items-end">
              <div>
                <h2 className="text-4xl font-black italic uppercase">System <span className="text-purple-500">Terminal</span></h2>
                <p className="text-slate-500 text-xs font-bold uppercase tracking-[0.3em] mt-2">Global Store Administration</p>
              </div>
              <button onClick={() => {setIsAdmin(false); setCurrentPage('home');}} className="bg-white/5 hover:bg-red-600/20 text-slate-400 hover:text-red-500 px-8 py-3 rounded-2xl font-black uppercase text-[10px] tracking-widest border border-slate-800 transition-all">Logout Session</button>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
              {/* Category Management */}
              <div className="bg-slate-900/30 border border-slate-800 p-8 rounded-[2.5rem]">
                <h3 className="font-black uppercase text-sm border-b border-slate-800 pb-4 mb-6 tracking-widest">Category Control</h3>
                <div className="flex gap-2 mb-8">
                  <input id="cat-in" type="text" placeholder="Category Name..." className="flex-grow bg-black border border-slate-800 p-4 rounded-xl outline-none focus:border-purple-600 transition-all text-sm" />
                  <button onClick={() => {
                    const el = document.getElementById('cat-in') as HTMLInputElement;
                    if (el.value) {
                      setCategories([...categories, { id: Date.now(), name: el.value.toUpperCase(), icon: "📁", desc: "Added by Admin" }]);
                      el.value = "";
                    }
                  }} className="bg-purple-600 px-6 rounded-xl font-black">+</button>
                </div>
                <div className="space-y-2">
                  {categories.map(c => (
                    <div key={c.id} className="flex justify-between items-center p-4 bg-slate-900 border border-slate-800 rounded-xl">
                      <span className="font-black text-xs uppercase tracking-widest">{c.icon} {c.name}</span>
                      <button onClick={() => setCategories(categories.filter(x => x.id !== c.id))} className="text-slate-600 hover:text-red-500 text-[10px] font-black uppercase transition-colors">Remove</button>
                    </div>
                  ))}
                </div>
              </div>

              {/* Product Management */}
              <div className="bg-slate-900/30 border border-slate-800 p-8 rounded-[2.5rem] space-y-4">
                <h3 className="font-black uppercase text-sm border-b border-slate-800 pb-4 mb-6 tracking-widest">Inventory Injection</h3>
                <div className="space-y-4">
                  <input id="p-name" type="text" placeholder="Product Name" className="w-full bg-black border border-slate-800 p-4 rounded-xl outline-none focus:border-purple-600 transition-all" />
                  <input id="p-img" type="text" placeholder="Image URL (Unsplash Link)" className="w-full bg-black border border-slate-800 p-4 rounded-xl outline-none focus:border-purple-600 transition-all text-xs" />
                  <div className="grid grid-cols-2 gap-4">
                    <input id="p-price" type="number" placeholder="Price" className="bg-black border border-slate-800 p-4 rounded-xl outline-none focus:border-purple-600 transition-all" />
                    <select id="p-cat" className="bg-black border border-slate-800 p-4 rounded-xl outline-none text-purple-500 font-bold">
                      {categories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
                    </select>
                  </div>
                  <button onClick={() => {
                    const name = (document.getElementById('p-name') as HTMLInputElement).value;
                    const img = (document.getElementById('p-img') as HTMLInputElement).value;
                    const price = Number((document.getElementById('p-price') as HTMLInputElement).value);
                    const catId = Number((document.getElementById('p-cat') as HTMLSelectElement).value);
                    
                    if (name && price > 0 && img) {
                      setProducts([...products, { id: Date.now(), name, price, catId, img, stock: 100 }]);
                      alert("✅ เพิ่มสินค้าเรียบร้อย!");
                    } else {
                      alert("❌ กรุณากรอกข้อมูลให้ครบถ้วน!");
                    }
                  }} className="w-full bg-white text-black py-5 rounded-2xl font-black uppercase tracking-[0.2em] text-xs hover:bg-purple-600 hover:text-white transition-all shadow-xl shadow-white/5">Deploy Product</button>
                </div>
              </div>
            </div>

            {/* Live Inventory Table */}
            <div className="bg-slate-900/30 border border-slate-800 rounded-[2.5rem] p-8 overflow-x-auto">
              <h3 className="font-black uppercase text-sm mb-6 tracking-widest italic text-purple-500">Live Inventory Database</h3>
              <table className="w-full text-left">
                <thead>
                  <tr className="text-[10px] text-slate-500 uppercase tracking-widest border-b border-slate-800">
                    <th className="pb-4">UID</th>
                    <th className="pb-4">Product Info</th>
                    <th className="pb-4">Category</th>
                    <th className="pb-4">Price</th>
                    <th className="pb-4">Stock</th>
                    <th className="pb-4 text-right">Operation</th>
                  </tr>
                </thead>
                <tbody className="text-sm">
                  {products.map(p => (
                    <tr key={p.id} className="border-b border-slate-900/50 hover:bg-white/[0.02] transition-colors">
                      <td className="py-4 font-mono text-slate-600 text-xs">#{p.id}</td>
                      <td className="py-4 font-black uppercase text-xs tracking-tight">{p.name}</td>
                      <td className="py-4 font-bold text-purple-600 text-xs">{categories.find(c => c.id === p.catId)?.name}</td>
                      <td className="py-4 font-black">{p.price} ฿</td>
                      <td className="py-4 font-mono text-xs">{p.stock}</td>
                      <td className="py-4 text-right">
                        <button onClick={() => setProducts(products.filter(x => x.id !== p.id))} className="bg-red-600/10 text-red-500 px-4 py-1 rounded-lg font-black text-[9px] uppercase hover:bg-red-600 hover:text-white transition-all">Destroy</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      <footer className="mt-20 py-10 border-t border-slate-900 text-center text-slate-700 text-[9px] font-black uppercase tracking-[0.5em]">
        Elite Digital Commerce System // 2026 // Global Release
      </footer>
    </div>
  );
}
