import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { useState, useEffect, createContext, useContext } from 'react';
import { createRoot } from 'react-dom/client';

// Import komponen halaman baru (Fase 6 & 7)
import LimitReachedPage from './LimitReached.jsx';
import ChallengeMenu from './ChallengeMenu.jsx';
import ChallengePlay from './ChallengePlay.jsx';
import Profile from './Profile.jsx';
import Points from './Points.jsx';

// Context Global
export const AppContext = createContext();

function App() {
  const [selectedApps, setSelectedApps] = useState([
    { name: "Instagram", logo: "instagram.png", timeLimit: "1h 42m", progress: 90 },
    { name: "TikTok", logo: "tiktok.png", timeLimit: "30m", progress: 70 },
    { name: "YouTube", logo: "youtube.png", timeLimit: "45m", progress: 85 },
    { name: "Facebook", logo: "facebook.png", timeLimit: "20m", progress: 95 }
  ]);

  const [userName] = useState("Dio");
  const [points, setPoints] = useState(240);

  return (
    <AppContext.Provider value={[selectedApps, setSelectedApps, userName, points, setPoints]}>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<SplashScreen />} />
          <Route path="/intro" element={<IntroPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignUpPage />} />
          <Route path="/permission" element={<PermissionPage />} />
          <Route path="/select-apps" element={<SelectAppsPage />} />
          <Route path="/set-limit" element={<SetLimitPage />} />
          <Route path="/home" element={<HomePage />} />
          <Route path="/statistics" element={<StatisticsPage />} />
          <Route path="/limit-reached" element={<LimitReachedPage />} />
          <Route path="/challenge" element={<ChallengeMenu />} />
          <Route path="/challenge/play" element={<ChallengePlay />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/points" element={<Points />} />
        </Routes>
      </BrowserRouter>
    </AppContext.Provider>
  );
}

// --- KOMPONEN HALAMAN LAMA ---

function SplashScreen() {
  const navigate = (path) => { window.location.href = path; };
  useEffect(() => {
    const timer = setTimeout(() => { navigate('/intro'); }, 3000);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="min-h-screen flex flex-col justify-center items-center bg-[#E3F0FB] p-6">
      <h1 className="text-5xl md:text-6xl font-extrabold text-[#1B2755] mb-4">ReFocus</h1>
      <p className="text-lg md:text-xl text-[#1B2755]">Reclaim Your Focus, Live Better</p>
      <div className="mt-8">
        <img src="/splash.png" alt="Owl with tablet" className="w-2/3 md:w-1/2 mx-auto" />
      </div>
    </div>
  );
}

function IntroPage() {
  const [currentStep, setCurrentStep] = useState(0);
  const slides = [
    { title: "Stay Focused, Achieve More", description: "ReFocus helps you track screen time and build healthy digital habits.", image: "intro-1.png" },
    { title: "Beat Distraction with Challenges", description: "Complete engaging challenges to strengthen your focus and reduce screen-related distractions.", image: "intro-2.png" },
    { title: "Track Progress, See Results", description: "Monitor your progress, set goals, and celebrate your achievements in building better focus habits.", image: "intro-3.png" }
  ];

  const handleNext = () => {
    if (currentStep < slides.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      window.location.href = '/login';
    }
  };

  return (
    <main className="min-h-screen w-full flex items-center justify-center p-6 bg-white">
      <div className="w-full max-w-6xl">
        <div className="md:flex md:flex-row md:items-center md:gap-8">
          <div className="md:w-1/2">
            <img src={`/assets/images/${slides[currentStep].image}`} alt={slides[currentStep].title} className="w-2/3 md:w-1/2 mx-auto" />
          </div>
          <div className="md:w-1/2 mt-6 md:mt-0">
            <h2 className="text-4xl md:text-5xl font-bold text-[#1B2755] mb-4 text-center md:text-left">{slides[currentStep].title}</h2>
            <p className="text-base md:text-lg text-[#1B2755] mb-6 text-center md:text-left">{slides[currentStep].description}</p>
            <div className="flex justify-center md:justify-start gap-2 mb-6">
              {slides.map((_, index) => (
                <div key={index} className={`w-2 h-2 rounded-full ${index === currentStep ? 'bg-[#1B2755]' : 'bg-white border border-[#1B2755]'}`} />
              ))}
            </div>
            <button onClick={handleNext} className="w-full md:w-auto px-8 py-4 bg-[#1B2755] text-white text-lg font-semibold rounded-xl hover:bg-opacity-90 transition-all">
              {currentStep < slides.length - 1 ? 'Next' : 'Start'}
            </button>
          </div>
        </div>
      </div>
    </main>
  );
}

function LoginPage() {
  const navigate = (path) => { window.location.href = path; };
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-white p-6">
      <img src="/assets/logo-refocus.png" alt="ReFocus Logo" className="h-8 mb-6 mx-auto object-contain" />
      <h1 className="text-2xl font-bold text-[#1A1A1A] text-center">Welcome back!</h1>
      <p className="text-sm text-[#204A94] text-center mb-6">Login to continue your journey.</p>
      <div className="w-full max-w-sm bg-white border border-[#A5C0DD] rounded-[2rem] p-6 relative shadow-[6px_10px_20px_rgba(220,232,245,0.8)]">
        <div className="space-y-4">
          <div><label className="text-sm font-bold text-[#204A94] mb-1 block">Email</label><input type="email" className="w-full border border-[#A5C0DD] rounded-xl px-4 py-3 text-sm outline-none focus:border-[#204A94]" /></div>
          <div><label className="text-sm font-bold text-[#204A94] mb-1 block">Password</label><input type="password" className="w-full border border-[#A5C0DD] rounded-xl px-4 py-3 text-sm outline-none focus:border-[#204A94]" /></div>
        </div>
        <div className="text-right mb-6 mt-2"><span className="text-xs font-bold text-[#204A94] cursor-pointer">Forgot password</span></div>
        <button onClick={() => navigate('/permission')} className="w-full bg-[#204A94] text-white font-bold py-3.5 rounded-2xl shadow-lg shadow-[#204A94]/30 mb-6">Login</button>
      </div>
      <div className="mt-6 text-sm text-gray-500">Don't have an account? <span className="font-bold text-[#204A94] cursor-pointer" onClick={() => navigate('/signup')}>Sign up</span></div>
    </div>
  );
}

function SignUpPage() {
  const navigate = (path) => { window.location.href = path; };
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-white p-6">
      <img src="/assets/logo-refocus.png" alt="ReFocus Logo" className="h-8 mb-6 mx-auto object-contain" />
      <h1 className="text-2xl font-bold text-[#1A1A1A] text-center">Create your account</h1>
      <p className="text-sm text-[#204A94] text-center mb-6">Let's get you started!</p>
      <div className="w-full max-w-sm bg-white border border-[#A5C0DD] rounded-[2rem] p-6 relative shadow-[6px_10px_20px_rgba(220,232,245,0.8)]">
        <div className="space-y-4">
          <div><label className="text-sm font-bold text-[#204A94] mb-1 block">Name</label><input type="text" className="w-full border border-[#A5C0DD] rounded-xl px-4 py-3 text-sm outline-none focus:border-[#204A94]" /></div>
          <div><label className="text-sm font-bold text-[#204A94] mb-1 block">Email</label><input type="email" className="w-full border border-[#A5C0DD] rounded-xl px-4 py-3 text-sm outline-none focus:border-[#204A94]" /></div>
          <div><label className="text-sm font-bold text-[#204A94] mb-1 block">Password</label><input type="password" className="w-full border border-[#A5C0DD] rounded-xl px-4 py-3 text-sm outline-none focus:border-[#204A94]" /></div>
        </div>
        <button onClick={() => navigate('/permission')} className="w-full bg-[#204A94] text-white font-bold py-3.5 rounded-2xl mt-6 shadow-lg shadow-[#204A94]/30 mb-6">Sign Up</button>
      </div>
      <div className="mt-6 text-sm text-gray-500">Already have an account? <span className="font-bold text-[#204A94] cursor-pointer" onClick={() => navigate('/login')}>Login</span></div>
    </div>
  );
}

function PermissionPage() {
  const navigate = (path) => { window.location.href = path; };
  return (
    <main className="min-h-screen bg-white flex flex-col items-center p-6">
      <div className="w-full max-w-md mx-auto">
        <img src="/assets/mascot-permission.png" alt="Mascot" className="w-40 mx-auto mb-4 object-contain" />
        <h1 className="text-3xl font-bold text-[#1B2755] text-center mb-2">Hampir sampai!</h1>
        <p className="text-sm font-semibold text-[#204A94] text-center mb-6 px-4">Untuk mempersonalisasi pengalaman Anda, kami membutuhkan beberapa izin</p>

        <div className="w-full border border-[#A5C0DD] rounded-2xl p-4 mb-4 flex items-center gap-4 shadow-[4px_6px_15px_rgba(220,232,245,0.6)] bg-white">
          <img src="/assets/icon-usage.png" alt="Usage" className="w-12 h-12 object-contain" />
          <div className="flex-1">
            <div className="font-bold text-[#1B2755] text-sm">Akses Penggunaan</div>
            <div className="text-xs text-gray-500 mt-0.5">Izinkan untuk melacak penggunaan aplikasi dan waktu layar.</div>
          </div>
          <div className="w-5 h-5 bg-[#204A94] rounded flex items-center justify-center flex-shrink-0">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
        </div>

        <div className="w-full border border-[#A5C0DD] rounded-2xl p-4 mb-4 flex items-center gap-4 shadow-[4px_6px_15px_rgba(220,232,245,0.6)] bg-white">
          <img src="/assets/icon-notification.png" alt="Notification" className="w-12 h-12 object-contain" />
          <div className="flex-1">
            <div className="font-bold text-[#1B2755] text-sm">Notifikasi</div>
            <div className="text-xs text-gray-500 mt-0.5">Izinkan untuk mengingatkan Anda tentang batasan dan tantangan.</div>
          </div>
          <div className="w-5 h-5 bg-[#204A94] rounded flex items-center justify-center flex-shrink-0">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="20 6 9 17 4 12" />
            </svg>
          </div>
        </div>

        <button className="w-full bg-[#204A94] text-white font-bold py-3.5 rounded-xl mt-4" onClick={() => navigate('/select-apps')}>Continue</button>
        <p className="text-xs text-gray-500 text-center mt-3 font-semibold">You can change this later</p>
      </div>
    </main>
  );
}

function SelectAppsPage() {
  const navigate = (path) => { window.location.href = path; };
  const [apps, setApps] = useState([
    { name: "Instagram", logo: "instagram.png", checked: true },
    { name: "TikTok", logo: "tiktok.png", checked: true },
    { name: "YouTube", logo: "youtube.png", checked: true },
    { name: "Facebook", logo: "facebook.png", checked: true },
    { name: "WhatsApp", logo: "whatsapp.png", checked: false },
    { name: "Shopee", logo: "shopee.png", checked: false }
  ]);

  const toggleApp = (index) => {
    setApps(apps.map((app, i) => i === index ? { ...app, checked: !app.checked } : app));
  };

  return (
    <main className="min-h-screen bg-white flex flex-col items-center p-6">
      <div className="w-full max-w-md mx-auto">
        <img src="/assets/mascot-select.png" alt="Mascot" className="w-32 mx-auto mb-4 object-contain" />
        <h1 className="text-3xl font-bold text-[#1B2755] text-center">Select Apps</h1>
        <p className="text-sm font-semibold text-[#204A94] text-center mt-1 mb-6">Pilih sosial media atau aplikasi yang anda ingin kelola</p>
        <div className="space-y-3 mt-2">
          {apps.map((app, index) => (
            <div key={index} onClick={() => toggleApp(index)} className="w-full border border-[#1B2755] rounded-xl p-3 mb-3 flex items-center justify-between bg-white cursor-pointer">
              <div className="flex items-center gap-3">
                <img src={`/assets/${app.logo}`} className="w-8 h-8 object-contain" alt={app.name} />
                <div className="text-[#204A94] font-bold text-sm">{app.name}</div>
              </div>
              <div className={`w-5 h-5 border-2 ${app.checked ? 'bg-[#204A94] border-[#204A94]' : 'bg-white border-[#204A94]'} rounded flex items-center justify-center`}>
                {app.checked && (
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                )}
              </div>
            </div>
          ))}
        </div>
        <button className="w-full bg-[#204A94] text-white font-bold py-3.5 rounded-xl mt-4" onClick={() => navigate('/set-limit')}>Continue</button>
        <p className="text-xs text-gray-500 text-center mt-3 font-semibold">You can change this later</p>
      </div>
    </main>
  );
}

function SetLimitPage() {
  const navigate = (path) => { window.location.href = path; };
  const limitApps = [
    { name: "Instagram", logo: "instagram.png", defaultLimit: "1 hour" },
    { name: "TikTok", logo: "tiktok.png", defaultLimit: "30 min" },
    { name: "YouTube", logo: "youtube.png", defaultLimit: "1 hour" },
    { name: "Facebook", logo: "facebook.png", defaultLimit: "30 min" }
  ];
  const [limits, setLimits] = useState(limitApps.map(a => a.defaultLimit));

  const updateLimit = (index, value) => {
    setLimits(limits.map((l, i) => i === index ? value : l));
  };

  return (
    <main className="min-h-screen bg-white flex flex-col items-center p-6">
      <div className="w-full max-w-md mx-auto">
        <img src="/assets/mascot-limit.png" alt="Mascot" className="w-32 mx-auto mb-4 object-contain" />
        <h1 className="text-3xl font-bold text-[#1B2755] text-center">Set Daily Limit</h1>
        <p className="text-sm font-semibold text-[#204A94] text-center mt-1 mb-6">Atur batas waktu harian Anda untuk setiap aplikasi</p>
        <div className="space-y-3 mt-2">
          {limitApps.map((app, index) => (
            <div key={index} className="w-full border border-[#1B2755] rounded-xl p-3 flex items-center justify-between bg-white shadow-sm">
              <div className="flex items-center gap-3">
                <img src={`/assets/${app.logo}`} className="w-8 h-8 object-contain" alt={app.name} />
                <div className="text-[#204A94] font-bold text-sm">{app.name}</div>
              </div>
              <select
                value={limits[index]}
                onChange={(e) => updateLimit(index, e.target.value)}
                className="border border-[#1B2755] rounded-lg px-3 py-1 text-[#204A94] font-bold text-sm bg-white outline-none cursor-pointer"
              >
                <option value="30 min">30 min</option>
                <option value="1 hour">1 hour</option>
                <option value="1 h 30 min">1 h 30 min</option>
                <option value="50 min">50 min</option>
              </select>
            </div>
          ))}
        </div>
        <button className="w-full bg-[#204A94] text-white font-bold py-3.5 rounded-xl mt-6" onClick={() => navigate('/home')}>Save & Start</button>
        <p className="text-xs text-gray-500 text-center mt-3 font-semibold">Anda dapat mengubah ini nanti</p>
      </div>
    </main>
  );
}

function HomePage() {
  const [selectedApps, , userName, points] = useContext(AppContext);

  const navigate = (path) => { window.location.href = path; };

  return (
    <div className="min-h-screen bg-[#F5F7FA] pb-28">
      <div className="p-6 max-w-lg mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <img src="/assets/logo-refocus.png" alt="ReFocus" className="h-12 w-auto" />
          <div className="relative cursor-pointer">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#1B2755" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
              <path d="M13.73 21a2 2 0 0 1-3.46 0" />
            </svg>
            <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full" />
          </div>
        </div>

        {/* Greeting */}
        <div className="flex items-center justify-between mb-8">
          <div className="flex-1">
            <h2 className="text-2xl font-bold text-[#1B2755] leading-tight">
              Good Morning,<br />{userName}!
            </h2>
            <p className="text-sm text-gray-500 mt-1">
              Let's stay focused and achieve your goals today
            </p>
          </div>
          <img src="/assets/mascot-cool.png" alt="Mascot" className="w-20 h-20 object-contain ml-4" />
        </div>

        {/* Focus Score */}
        <div className="bg-[#1B2755] rounded-2xl p-6 mb-6 text-white">
          <div className="flex justify-between items-center">
            <div>
              <div className="text-sm text-white/70">Focus Score</div>
              <div className="text-5xl font-bold mt-1">
                82<span className="text-2xl text-white/60">/100</span>
              </div>
              <div className="mt-3">
                <span className="bg-white/15 text-white text-xs font-semibold px-3 py-1 rounded-full">
                  Excellent!
                </span>
              </div>
            </div>
            <div className="relative w-28 h-28">
              <svg className="w-full h-full -rotate-90" viewBox="0 0 100 100">
                <circle cx="50" cy="50" r="45" stroke="#25407a" strokeWidth="8" fill="none" />
                <circle
                  cx="50" cy="50" r="45" stroke="#38BDF8" strokeWidth="8" fill="none"
                  strokeDasharray="283" strokeDashoffset="57" strokeLinecap="round"
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center text-center leading-tight">
                <span className="text-xs font-semibold">You're doing</span>
                <span className="text-xs font-semibold">great today!</span>
              </div>
            </div>
          </div>
        </div>

        {/* Daily Stats */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <div className="text-xs text-gray-500 mb-1">Today's Screen Time</div>
            <div className="text-3xl font-bold text-gray-800">1h 42m</div>
            <div className="flex items-center mt-2 text-green-600">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" className="mr-1">
                <polyline points="18 15 12 9 6 15" />
              </svg>
              <span className="text-xs font-medium">10% from yesterday</span>
            </div>
          </div>
          <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            <div className="text-xs text-gray-500 mb-1">Current Streak</div>
            <div className="flex items-baseline">
              <span className="text-3xl font-bold text-[#204A94]">7</span>
              <span className="text-lg text-gray-600 ml-1">Days</span>
            </div>
            <div className="text-xs text-[#204A94] font-medium mt-2">
              {points} pts &middot; Keep it up!
            </div>
          </div>
        </div>

        {/* Social Media Limits */}
        <div className="mb-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-bold text-[#1B2755]">Your Social Media Limits</h3>
            <button
              onClick={() => navigate('/select-apps')}
              className="text-sm font-semibold text-[#204A94] bg-[#E0F2FE] px-3 py-1.5 rounded-lg"
            >
              Edit Limits
            </button>
          </div>
          <div className="space-y-3">
            {selectedApps.map((app, index) => (
              <div key={index} className="flex items-center justify-between bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                <div className="flex items-center gap-3">
                  <img src={`/assets/${app.logo}`} alt={app.name} className="w-10 h-10 rounded-xl object-contain" />
                  <div>
                    <div className="font-semibold text-[#1B2755] text-sm">{app.name}</div>
                    <div className="text-xs text-gray-400">{app.timeLimit}</div>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <span className="bg-[#E0F2FE] text-[#204A94] text-xs font-bold px-2 py-1 rounded-full min-w-[40px] text-center">
                    {app.progress}%
                  </span>
                  <div className="w-16 h-1.5 bg-gray-200 rounded-full overflow-hidden">
                    <div className="h-full bg-[#38BDF8] rounded-full" style={{ width: `${app.progress}%` }} />
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Bottom Cards */}
        <div className="grid grid-cols-2 gap-4 mb-8">
          <div className="bg-[#E0F2FE] rounded-xl p-4 flex flex-col">
            <h4 className="text-sm font-bold text-[#1B2755] mb-1">Today's Challenge</h4>
            <p className="text-xs text-gray-600 mb-3 flex-1">
              Train your memory and improve focus in just 2 minutes!
            </p>
            <button
              onClick={() => navigate('/challenge')}
              className="w-full bg-[#1B2755] text-white text-sm font-bold py-2.5 rounded-lg mt-auto"
            >
              Start Challenge
            </button>
          </div>
          <div className="bg-[#E0F2FE] rounded-xl p-4 flex flex-col">
            <div className="flex items-center gap-1.5 mb-1">
              <span className="text-base">💡</span>
              <h4 className="text-sm font-bold text-[#1B2755]">Daily Insight</h4>
            </div>
            <p className="text-xs text-gray-600 flex-1">
              You spend the most time on social media between 8-10 PM. Try to take a break during that time tomorrow!
            </p>
          </div>
        </div>
      </div>
      <BottomNavigation activePage="home" />
    </div>
  );
}

function DashboardPage() {
  return <div className="min-h-screen flex items-center justify-center bg-[#E3F0FB] p-6"><h1 className="text-4xl font-bold text-[#1B2755]">Dashboard</h1></div>;
}

function StatisticsPage() {
  const [selectedApps] = useContext(AppContext);
  const [activeTab, setActiveTab] = useState('Ikhtisar');
  const tabs = ['Ikhtisar', 'Harian', 'Mingguan', 'Bulanan'];
  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  const chartPoints = [
    { x: 'Sen', y: 60 }, { x: 'Sel', y: 72 }, { x: 'Rab', y: 65 },
    { x: 'Kam', y: 78 }, { x: 'Jum', y: 82 }, { x: 'Sab', y: 75 }, { x: 'Min', y: 80 }
  ];

  const svgW = 260, svgH = 120, padL = 0, padR = 0, padT = 10, padB = 20;
  const chartW = svgW - padL - padR, chartH = svgH - padT - padB;
  const minY = Math.min(...chartPoints.map(p => p.y));
  const maxY = Math.max(...chartPoints.map(p => p.y));
  const range = maxY - minY || 1;
  const pts = chartPoints.map((p, i) => {
    const x = padL + (i / (chartPoints.length - 1)) * chartW;
    const y = padT + chartH - ((p.y - minY) / range) * chartH * 0.8 - chartH * 0.1;
    return `${x},${y}`;
  });
  const lineD = pts.map((p, i) => `${i === 0 ? 'M' : 'L'}${p}`).join(' ');

  return (
    <div className="min-h-screen bg-[#F5F7FA] pb-28">
      {/* Header */}
      <div className="bg-[#1B2755] rounded-b-[2.5rem] pt-12 pb-8 px-6 relative text-white">
        <h1 className="text-3xl font-bold mb-1">Statistik</h1>
        <p className="text-sm max-w-[60%] text-gray-300">Lacak kemajuan Anda dan bangun kebiasaan digital yang lebih baik.</p>
        <img src="/assets/mascot-stats.png" alt="Mascot" className="absolute bottom-0 right-4 w-28 object-contain" />
      </div>

      {/* Tabs */}
      <div className="flex justify-between bg-[#E3F0FB] p-1.5 rounded-full mx-6 mt-4">
        {tabs.map(tab => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`flex-1 text-center rounded-full px-4 py-1.5 text-sm font-bold transition-colors ${
              activeTab === tab ? 'bg-[#1B2755] text-white' : 'text-[#1B2755]'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Metrics Cards */}
      <div className="grid grid-cols-2 gap-4 mx-6 mt-6">
        <div className="bg-white rounded-2xl p-4 shadow-sm">
          <div className="text-xs text-gray-500 mb-1">Focus Score</div>
          <div className="text-3xl font-bold text-[#1B2755]">82%</div>
          <div className="text-xs text-blue-600 font-bold mt-1">↗ +12% vs last week</div>
        </div>
        <div className="bg-gradient-to-br from-[#4AA5F9] to-[#1B2755] rounded-2xl p-4 text-white shadow-sm">
          <div className="text-xs opacity-80">Daily Average</div>
          <div className="text-3xl font-bold mt-0.5">3h 42m</div>
          <div className="text-xs opacity-80 mt-1 flex items-center gap-1">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            Down by 45m
          </div>
        </div>
        <div className="bg-white rounded-2xl p-4 shadow-sm flex flex-col">
          <div className="text-xs text-gray-500 mb-1">Today's Screen Time</div>
          <div className="text-3xl font-bold text-gray-800">1h 42m</div>
          <div className="text-xs font-medium text-green-600 mt-1">↓ 10% from yesterday</div>
          <div className="flex items-end gap-0.5 mt-3 h-8">
            {[40,55,70,45,60,80,65,50,75,90,85,60].map((h, i) => (
              <div key={i} className="flex-1 bg-[#E0F2FE] rounded-t-sm" style={{ height: `${h * 0.4}px` }} />
            ))}
          </div>
        </div>
        <div className="bg-white rounded-2xl p-4 shadow-sm flex flex-col">
          <div className="text-xs text-gray-500 mb-1">Current Streak</div>
          <div className="text-3xl font-bold text-[#1B2755]">7 Days</div>
          <div className="text-xs font-medium text-blue-600 mt-1">🔥 Keep it up!</div>
          <div className="flex gap-1.5 mt-3">
            {days.map((d, i) => (
              <div key={i} className="w-7 h-7 rounded-full bg-[#204A94] flex items-center justify-center">
                <span className="text-white text-[9px] font-bold">{d}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Chart: Focus Trend */}
      <div className="bg-white rounded-2xl p-4 mx-6 mt-6 shadow-sm">
        <div className="flex justify-between items-start mb-1">
          <div>
            <div className="font-bold text-[#1B2755]">Tren Fokus</div>
            <div className="text-xs text-gray-500">Konsistensi meningkat sebesar 15%</div>
          </div>
          <div className="flex items-center gap-1">
            <span className="w-2 h-2 rounded-full bg-[#38BDF8]" />
            <span className="text-[10px] text-gray-400">Focus</span>
          </div>
        </div>
        <svg viewBox={`0 0 ${svgW} ${svgH}`} className="w-full h-28 mt-1 overflow-visible">
          <defs>
            <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#38BDF8" stopOpacity="0.25" />
              <stop offset="100%" stopColor="#38BDF8" stopOpacity="0" />
            </linearGradient>
          </defs>
          <path d={`${lineD}`} fill="none" stroke="#38BDF8" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
          <path d={`${lineD} L${padL + chartW},${padT + chartH} L${padL},${padT + chartH} Z`} fill="url(#areaGrad)" />
          {chartPoints.map((p, i) => {
            const x = padL + (i / (chartPoints.length - 1)) * chartW;
            const y = padT + chartH - ((p.y - minY) / range) * chartH * 0.8 - chartH * 0.1;
            return (
              <g key={i}>
                <circle cx={x} cy={y} r="3" fill="#38BDF8" stroke="white" strokeWidth="1.5" />
                <text x={x} y={padT + chartH + 12} textAnchor="middle" fill="#9CA3AF" fontSize="8">{p.x}</text>
              </g>
            );
          })}
        </svg>
      </div>

      {/* App Breakdown */}
      <div className="bg-white rounded-2xl p-4 mx-6 mt-6 mb-24 shadow-sm">
        <div className="flex justify-between items-center mb-4">
          <span className="font-bold text-[#1B2755] text-sm">Most Used Apps</span>
          <span className="text-xs font-semibold text-[#204A94]">See All</span>
        </div>
        <div className="space-y-3">
          {selectedApps.map((app, index) => (
            <div key={index} className="flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <img src={`/assets/${app.logo}`} alt={app.name} className="w-8 h-8 rounded-lg object-contain" />
                <div>
                  <div className="text-sm font-semibold text-[#1B2755]">{app.name}</div>
                  <div className="text-xs text-gray-400">{app.timeLimit}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <span className="bg-[#E0F2FE] text-[#204A94] text-xs font-bold px-2 py-0.5 rounded-full">{app.progress}%</span>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                  <polyline points="9 18 15 12 9 6" />
                </svg>
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNavigation activePage="statistics" />
    </div>
  );
}

// Komponen navigasi bawah agar bisa dipanggil di mana saja
export function BottomNavigation({ activePage }) {
  const navigate = (path) => { window.location.href = path; };
  
  const navItems = [
    { path: '/home', icon: '/assets/nav-home.png', label: 'Home' },
    { path: '/statistics', icon: '/assets/nav-stats.png', label: 'Statistics' },
    { path: '/challenge', icon: '/assets/nav-challenge.png', label: 'Challenge' },
    { path: '/profile', icon: '/assets/nav-profile.png', label: 'Profile' }
  ];
  
  return (
    <div className="fixed bottom-0 left-0 right-0 w-full max-w-md mx-auto bg-white border-t border-gray-200 flex justify-around items-center py-3 px-2 z-50 rounded-t-3xl shadow-[0_-4px_15px_rgba(0,0,0,0.05)]">
      {navItems.map((item) => (
        <button
          key={item.path}
          onClick={() => navigate(item.path)}
          className="flex flex-col items-center focus:outline-none"
        >
          <div className={`w-8 h-8 rounded-full flex items-center justify-center mb-1 ${
            activePage === item.label.toLowerCase() ? 'bg-[#E0F2FE]' : ''
          }`}>
            <img 
              src={item.icon} 
              alt={item.label} 
              className={`w-5 h-5 ${
                activePage === item.label.toLowerCase() ? 'opacity-100' : 'opacity-40'
              }`}
            />
          </div>
          <span className={`text-[10px] ${
            activePage === item.label.toLowerCase() ? 'text-[#1B2755] font-bold' : 'text-gray-400'
          }`}>
            {item.label}
          </span>
        </button>
      ))}
    </div>
  );
}

// --- RENDER KE LAYAR ---
const rootElement = document.getElementById('root');
if (rootElement) {
  const root = createRoot(rootElement);
  root.render(<App />);
}