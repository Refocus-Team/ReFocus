import { useState, useEffect } from 'react';

function LimitReachedPage() {
  const [timeLeft, setTimeLeft] = useState(900);

  useEffect(() => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => Math.max(0, prev - 1));
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const navigate = (path) => {
    window.location.href = path;
  };

  return (
    <div className="min-h-screen bg-[#1B2755] text-white flex flex-col items-center justify-center p-6">
      <div className="relative">
        <div className="w-64 h-64 rounded-full border-4 border-gray-600 relative">
          <div
            className="absolute inset-0 rounded-full border-4 border-[#A5C0DD]"
            style={{
              clipPath: `polygon(50% 50%, 50% 0%, ${Math.max(0, 100 - (timeLeft / 900 * 100))}% 0%, ${Math.max(0, 100 - (timeLeft / 900 * 100))}% 100%, 50% 100%)`
            }}
          />
        </div>
        <img
          src="/assets/mascot-locked.png"
          alt="Mascot"
          className="w-48 absolute inset-0 mx-auto object-contain"
        />
      </div>

      <h1 className="text-3xl font-bold mt-8">Time Limit Reached!</h1>
      <p className="text-gray-300 text-center px-4 mb-10">
        You've reached your daily limit for TikTok
      </p>

      <button
        onClick={() => navigate('/challenge')}
        className="w-full max-w-sm bg-[#204A94] rounded-xl py-4 font-bold mb-4"
      >
        Start Challenge
      </button>

      <button
        onClick={() => {}}
        className="w-full max-w-sm bg-transparent border border-[#A5C0DD] rounded-xl py-4 font-bold mb-4"
      >
        Remind Me Later
      </button>

      <div className="text-sm text-gray-400 font-semibold">
        or wait {formatTime(timeLeft)}
      </div>
    </div>
  );
}

export default LimitReachedPage;