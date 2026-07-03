import { useState, useContext } from 'react';
import { AppContext, BottomNavigation } from './index.jsx';

function ChallengeMenu() {
  const [selectedApps, setSelectedApps, userName, points, setPoints] = useContext(AppContext);

  const [challenges] = useState([
    { title: "Memory Match", description: "Train your memory and attention.", points: 10 },
    { title: "Color Focus", description: "Match colors quickly and accurately.", points: 15 },
    { title: "Math Sprint", description: "Solve math problems in time.", points: 20 },
    { title: "Pattern Recall", description: "Remember and repeat patterns.", points: 25 }
  ]);

  const navigate = (path) => {
    window.location.href = path;
  };

  return (
    <div className="min-h-screen bg-[#1B2755] text-white">
      <div className="bg-[#1B2755] pt-12 pb-8 px-6 relative text-white">
        <h1 className="text-3xl font-bold text-white">Challenge</h1>
        <div className="flex justify-between items-center mt-4">
          <div>
            <div className="text-sm text-gray-300">POINTS</div>
            <div className="font-bold text-2xl">{points}</div>
          </div>
          <img
            src="/assets/mascot-cool.png"
            alt="Mascot"
            className="w-24 absolute right-4 -mt-4 object-contain"
          />
        </div>
      </div>

      <div className="bg-white rounded-t-[2.5rem] min-h-screen pb-24">
        <div className="flex gap-2 px-6 mt-6">
          {['All', 'Daily', 'Completed'].map((tab, index) => (
            <button
              key={tab}
              className={`flex-1 py-2 rounded-lg font-bold text-sm ${index === 1 ? 'bg-[#1B2755] text-white' : 'bg-white text-[#1B2755] border border-[#1B2755]'}`}
            >
              {tab}
            </button>
          ))}
        </div>

        <div className="px-6 space-y-4 mt-4">
          {challenges.map((challenge, index) => (
            <div
              key={index}
              className="bg-[#E3F0FB] rounded-2xl p-4 shadow-sm flex justify-between items-center"
            >
              <div>
                <div className="text-[#1B2755] font-bold mb-1">{challenge.title}</div>
                <div className="text-[#204A94] text-xs w-2/3">{challenge.description}</div>
                <div className="mt-2">
                  <span className="text-orange-500 font-bold">+{challenge.points}</span>
                  <span className="text-[#1B2755] font-bold"> pts</span>
                </div>
              </div>
              <button
                onClick={() => navigate('/challenge/play')}
                className="bg-[#204A94] text-white px-6 py-2 rounded-lg font-bold"
              >
                Start
              </button>
            </div>
          ))}
        </div>
      </div>
      <BottomNavigation activePage="challenge" />
    </div>
  );
}

export default ChallengeMenu;
