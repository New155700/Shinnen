"use client";
import React, { useState, useReducer, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  ShoppingCart, User, ShieldCheck, Settings, 
  Plus, Minus, Trash2, LogIn, LayoutDashboard,
  Palette, Package, Zap, Globe
} from 'lucide-react';

// --- 1. CONFIG & THEME ENGINE ---
const INITIAL_PRODUCTS = [
  { id: 1, name: "Netflix Ultra HD", price: 150, stock: 45, img: "https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=500", cat: "Premium" },
  { id: 2, name: "Youtube Family", price: 59, stock: 120, img: "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=500", cat: "Premium" },
];

// --- 2. GLOBAL STATE REDUCER ---
const shopReducer = (state, action) => {
  switch (action.type) {
    case 'SET_THEME': return { ...state, themeColor: action.payload };
    case 'LOGIN_GOOGLE': return { ...state, user: action.payload, isLogged: true };
    case 'ADD_TO_CART': 
      const existing = state.cart.find(i => i.id === action.payload.id);
      if (existing) return {
        ...state,
        cart: state.cart.map(i => i.id === action.payload.id ? {...i, qty: i.qty + 1} : i)
      };
      return { ...state, cart: [...state.cart, { ...action.payload, qty: 1 }] };
    case 'UPDATE_QTY':
      return { ...state, cart: state.cart.map(i => i.id === action.id ? {...i, qty: Math.max(1, i.qty + action.val)} : i) };
    case 'REMOVE_CART': return { ...state, cart: state.cart.filter(i => i.id !== action.id) };
    case 'CHECKOUT': return { ...state, user: { ...state.user, balance: state.user.balance - action.total }, cart: [] };
    default: return state;
  }
};

export default function LoveShopQuantumGodMode() {
  const [state, dispatch] = useReducer(shopReducer, {
    user: { name: "Guest User", balance: 12500, avatar: "" },
    cart: [],
    isLogged: false,
    themeColor: '#a855f7', // Default Purple
    products: INITIAL_PRODUCTS
  });

  const [view, setView] = useState('home'); // home | admin | profile
  const [isCartOpen, setIsCartOpen] = useState(false);

  const cartTotal = state.cart.reduce((s, i) => s + (i.price * i.qty), 0);

  return (
    <div className="min-h-screen bg-[#020205] text-white font-sans selection:bg-white/20">
      
      {/* 🔮 DYNAMIC AMBIENT LIGHTING */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        <motion.div 
          animate={{ scale: [1, 1.2, 1], opacity: [0.3, 0.5, 0.3] }}
          transition={{ duration: 8, repeat: Infinity }}
          style={{ backgroundColor: state.themeColor }}
          className="absolute -top-1/4 -left-1/4 w-1/2 h-1/2 blur-[160px] rounded-full opacity-30" 
        />
      </div>

      {/* 🧭 NEXT-GEN NAVIGATION */}
      <nav className="sticky top-0 z-[100] border-b border-white/5 bg-black/40 backdrop-blur-2xl px-8 py-4 flex justify-between items-center">
        <div className="flex items-center gap-8">
          <motion.h1 
            whileHover={{ scale: 1.05 }}
            onClick={() => setView('home')}
            className="text-2xl font-black italic tracking-tighter cursor-pointer flex items-center gap-2"
          >
            <Zap size={28} fill={state.themeColor} stroke={state.themeColor} />
            QUANTUM<span style={{ color: state.themeColor }}>SHOP</span>
          </motion.h1>
        </div>

        <div className="flex items-center gap-5">
          {!state.isLogged ? (
            <button 
              onClick={() => dispatch({ type: 'LOGIN_GOOGLE', payload: { name: "Quantum Member", balance: 5000 } })}
              className="flex items-center gap-2 bg-white/5 hover:bg-white/10 px-6 py-2.5 rounded-full border border-white/10 transition-all text-sm font-bold"
            >
              <LogIn size={18} /> Login with Google
            </button>
          ) : (
            <div className="flex items-center gap-4">
              <div className="text-right hidden md:block">
                <p className="text-[10px] font-bold opacity-40 uppercase tracking-widest">Balance</p>
                <p className="font-black text-sm">{state.user.balance.toLocaleString()} ฿</p>
              </div>
              <button onClick={() => setView('admin')} className="p-3 bg-white/5 rounded-full hover:bg-white/10 border border-white/10">
                <LayoutDashboard size={20} />
              </button>
            </div>
          )}
          
          <button onClick={() => setIsCartOpen(true)} className="relative p-3 bg-white text-black rounded-full hover:scale-110 transition-transform">
            <ShoppingCart size={20} />
            {state.cart.length > 0 && (
              <span style={{ backgroundColor: state.themeColor }} className="absolute -top-1 -right-1 w-5 h-5 rounded-full text-[10px] font-bold text-white flex items-center justify-center border-2 border-black">
                {state.cart.length}
              </span>
            )}
          </button>
        </div>
      </nav>

      {/* 🎭 MAIN VIEW ENGINE */}
      <main className="relative z-10 max-w-7xl mx-auto p-8">
        <AnimatePresence mode="wait">
          
          {/* VIEW: HOME PAGE */}
          {view === 'home' && (
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="space-y-16">
              
              {/* HERO SECTION */}
              <section className="relative h-[50vh] rounded-[3rem] overflow-hidden flex items-center px-12 border border-white/10 shadow-2xl">
                <img src="https://images.unsplash.com/photo-1614850523296-d8c1af93d400?w=1200" className="absolute inset-0 w-full h-full object-cover opacity-30" />
                <div className="relative z-10 space-y-6">
                  <motion.div initial={{ y: 20 }} animate={{ y: 0 }} className="inline-block px-4 py-1 bg-white/10 rounded-full text-[10px] font-black uppercase tracking-[0.3em] border border-white/10">
                    Premium Digital Hub
                  </motion.div>
                  <h2 className="text-7xl font-black italic leading-none tracking-tighter">UNLEASH THE<br/> <span style={{ color: state.themeColor }}>POTENTIAL.</span></h2>
                  <p className="text-white/40 font-medium max-w-lg">สัมผัสประสบการณ์การซื้อสินค้าดิจิทัลที่ลื่นไหลที่สุด ด้วยระบบ Quantum Secure และ UI ที่ปรับแต่งมาเพื่อคุณ</p>
                </div>
              </section>

              {/* PRODUCT GRID */}
              <section className="grid grid-cols-1 md:grid-cols-3 gap-10">
                {state.products.map(p => (
                  <motion.div 
                    layoutId={`p-${p.id}`}
                    key={p.id}
                    className="group bg-white/[0.03] border border-white/5 rounded-[2.5rem] p-6 hover:bg-white/[0.06] transition-all"
                  >
                    <div className="relative h-60 rounded-[2rem] overflow-hidden mb-6">
                      <img src={p.img} className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700" />
                      <div className="absolute top-4 right-4 bg-black/60 backdrop-blur-md px-4 py-1.5 rounded-full text-[10px] font-black border border-white/10">
                        IN STOCK: {p.stock}
                      </div>
                    </div>
                    <div className="flex justify-between items-end">
                      <div className="space-y-1">
                        <p className="text-[10px] font-black opacity-30 uppercase tracking-widest">{p.cat}</p>
                        <h3 className="text-2xl font-black italic uppercase tracking-tighter">{p.name}</h3>
                        <p className="text-2xl font-light opacity-80">{p.price} <span className="text-sm">฿</span></p>
                      </div>
                      <motion.button 
                        whileTap={{ scale: 0.9 }}
                        onClick={() => dispatch({ type: 'ADD_TO_CART', payload: p })}
                        style={{ backgroundColor: state.themeColor }}
                        className="p-4 rounded-2xl shadow-lg hover:brightness-125 transition-all"
                      >
                        <Plus size={24} />
                      </motion.button>
                    </div>
                  </motion.div>
                ))}
              </section>
            </motion.div>
          )}

          {/* VIEW: ADMIN GOD-MODE */}
          {view === 'admin' && (
            <motion.div initial={{ x: 100 }} animate={{ x: 0 }} exit={{ x: -100 }} className="grid grid-cols-1 lg:grid-cols-3 gap-10">
              <div className="lg:col-span-1 space-y-8">
                <div className="bg-white/[0.03] border border-white/10 p-8 rounded-[2.5rem]">
                  <h3 className="flex items-center gap-3 text-xl font-black italic uppercase mb-8">
                    <Palette size={24} style={{ color: state.themeColor }} /> System Theme
                  </h3>
                  <div className="grid grid-cols-4 gap-4">
                    {['#a855f7', '#3b82f6', '#ef4444', '#10b981'].map(color => (
                      <button 
                        key={color} 
                        onClick={() => dispatch({ type: 'SET_THEME', payload: color })}
                        style={{ backgroundColor: color }} 
                        className={`h-12 rounded-2xl border-4 ${state.themeColor === color ? 'border-white' : 'border-transparent'}`}
                      />
                    ))}
                  </div>
                </div>
              </div>

              <div className="lg:col-span-2 bg-white/[0.03] border border-white/10 p-10 rounded-[3rem]">
                <h3 className="text-2xl font-black italic uppercase mb-8 flex items-center gap-3">
                  <Package size={24} /> Inventory Master Control
                </h3>
                {/* Simulated Product Edit Table */}
                <div className="space-y-4">
                  {state.products.map(p => (
                    <div key={p.id} className="flex items-center justify-between p-6 bg-black/40 rounded-3xl border border-white/5">
                      <div className="flex items-center gap-5">
                        <img src={p.img} className="w-16 h-16 rounded-2xl object-cover" />
                        <div>
                          <p className="font-black uppercase text-sm">{p.name}</p>
                          <p className="text-xs opacity-40">UID: {p.id * 882}</p>
                        </div>
                      </div>
                      <div className="flex gap-10 items-center">
                        <div className="text-right">
                          <p className="text-[10px] font-black opacity-30">PRICE</p>
                          <input type="number" defaultValue={p.price} className="bg-transparent text-right font-bold w-20 outline-none focus:text-purple-400" />
                        </div>
                        <button className="p-3 text-red-500 bg-red-500/10 rounded-xl hover:bg-red-500 hover:text-white transition-all"><Trash2 size={18} /></button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>
          )}

        </AnimatePresence>
      </main>

      {/* 🛍️ QUANTUM CART DRAWER (ขวา) */}
      <AnimatePresence>
        {isCartOpen && (
          <>
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={() => setIsCartOpen(false)} className="fixed inset-0 z-[200] bg-black/60 backdrop-blur-sm" />
            <motion.div initial={{ x: '100%' }} animate={{ x: 0 }} exit={{ x: '100%' }} transition={{ type: 'spring', damping: 25 }} className="fixed top-0 right-0 h-full w-full md:w-[450px] z-[201] bg-[#0a0a0f] border-l border-white/10 p-10 flex flex-col shadow-[-50px_0_100px_rgba(0,0,0,0.5)]">
              <div className="flex justify-between items-center mb-12">
                <h3 className="text-3xl font-black italic uppercase">Your <span style={{ color: state.themeColor }}>Cart</span></h3>
                <button onClick={() => setIsCartOpen(false)} className="text-white/40 hover:text-white uppercase font-black text-xs tracking-widest">Close</button>
              </div>

              <div className="flex-grow overflow-y-auto space-y-6 pr-2">
                {state.cart.map(item => (
                  <div key={item.id} className="flex gap-5 items-center p-4 bg-white/5 rounded-3xl border border-white/5">
                    <img src={item.img} className="w-20 h-20 rounded-2xl object-cover" />
                    <div className="flex-grow">
                      <p className="font-black uppercase text-xs tracking-tight">{item.name}</p>
                      <p className="font-bold text-lg">{item.price * item.qty} ฿</p>
                      <div className="flex items-center gap-4 mt-2">
                        <button onClick={() => dispatch({ type: 'UPDATE_QTY', id: item.id, val: -1 })} className="p-1 hover:text-purple-400"><Minus size={16} /></button>
                        <span className="font-black text-sm">{item.qty}</span>
                        <button onClick={() => dispatch({ type: 'UPDATE_QTY', id: item.id, val: 1 })} className="p-1 hover:text-purple-400"><Plus size={16} /></button>
                      </div>
                    </div>
                    <button onClick={() => dispatch({ type: 'REMOVE_CART', id: item.id })} className="text-white/20 hover:text-red-500"><Trash2 size={20} /></button>
                  </div>
                ))}
              </div>

              <div className="mt-10 pt-10 border-t border-white/10 space-y-6">
                <div className="flex justify-between text-2xl font-black uppercase italic">
                  <span>Total</span>
                  <span style={{ color: state.themeColor }}>{cartTotal.toLocaleString()} ฿</span>
                </div>
                <button 
                  onClick={() => {
                    if(state.user.balance >= cartTotal) {
                      dispatch({ type: 'CHECKOUT', total: cartTotal });
                      alert("Purchase Successful!");
                    } else alert("Insufficient Balance!");
                  }}
                  style={{ backgroundColor: state.themeColor }}
                  className="w-full py-5 rounded-[2rem] font-black uppercase tracking-[0.2em] shadow-2xl shadow-purple-500/20 active:scale-95 transition-all"
                >
                  Confirm Checkout
                </button>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}
