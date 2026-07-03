import { useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppContext, BottomNavigation } from './index.jsx';

function Profile() {
  const [selectedApps, setSelectedApps, userName, points, setPoints] = useContext(AppContext);
  const navigate = useNavigate();
  const base = import.meta.env.BASE_URL;

  return (
    <div className="min-h-screen bg-[#F5F7FA] pb-24 relative p-6">
      <img
        src={`${base}assets/icon-settings.png`}
        alt="Settings"
        className="w-6 h-6 absolute top-6 right-6 cursor-pointer"
      />

      <div className="relative mt-10 mx-auto w-28 h-28">
        <img
          src={`${base}assets/profile-avatar.png`}
          alt="Profile"
          className="w-full h-full rounded-full object-cover shadow-md"
        />
        <div className="bg-white rounded-full p-1.5 shadow-sm absolute bottom-0 right-0 border border-gray-100">
          <img
            src={`${base}assets/icon-camera.png`}
            alt="Camera"
            className="w-5 h-5"
          />
        </div>
      </div>

      <h1 className="text-3xl font-bold text-[#1B2755] text-center mt-4">
        {userName}
      </h1>

      <div className="text-sm font-bold text-[#204A94] text-center mt-1">
        Level 5 | Focus Master
      </div>

      <div className="w-full max-w-xs mx-auto h-3 bg-gray-200 rounded-full mt-4 relative overflow-hidden">
        <div
          className="absolute inset-y-0 left-0 bg-[#204A94] transition-all duration-500"
          style={{ width: '65%' }}
        ></div>
      </div>
      <div className="text-xs font-bold text-[#1B2755] text-center mt-2">
        520/800 XP
      </div>

      <div className="bg-white rounded-2xl p-5 mt-6 shadow-sm border border-gray-100 flex justify-between items-center max-w-sm mx-auto w-full">
        <div className="text-center">
          <div className="text-xs font-bold text-[#1B2755]">Focus Score</div>
          <div className="text-3xl font-bold text-[#204A94]">82</div>
        </div>
        <div className="text-center">
          <div className="text-xs font-bold text-[#1B2755]">Streak</div>
          <div className="text-3xl font-bold text-[#204A94]">7 Days</div>
        </div>
        <div className="text-center">
          <div className="text-xs font-bold text-[#1B2755]">Challenge</div>
          <div className="text-3xl font-bold text-[#204A94]">12</div>
        </div>
      </div>

      <div className="flex justify-between items-center mt-8 mb-4 max-w-sm mx-auto w-full">
        <div className="font-bold text-[#1B2755]">Achievements</div>
        <div className="text-xs font-bold text-[#204A94] cursor-pointer">
          See all
        </div>
      </div>

      <div className="flex justify-between items-start max-w-sm mx-auto w-full gap-2">
        <div className="text-center">
          <img
            src={`${base}assets/ach-1.png`}
            alt="First step"
            className="w-16 h-16 object-contain"
          />
          <div className="text-[10px] font-bold text-[#204A94] text-center mt-1">
            First step
          </div>
        </div>
        <div className="text-center">
          <img
            src={`${base}assets/ach-2.png`}
            alt="Time tracker"
            className="w-16 h-16 object-contain"
          />
          <div className="text-[10px] font-bold text-[#204A94] text-center mt-1">
            Time tracker
          </div>
        </div>
        <div className="text-center">
          <img
            src={`${base}assets/ach-3.png`}
            alt="Limit setter"
            className="w-16 h-16 object-contain"
          />
          <div className="text-[10px] font-bold text-[#204A94] text-center mt-1">
            Limit setter
          </div>
        </div>
        <div className="text-center">
          <img
            src={`${base}assets/ach-4.png`}
            alt="Locked in"
            className="w-16 h-16 object-contain"
          />
          <div className="text-[10px] font-bold text-[#204A94] text-center mt-1">
            Locked in
          </div>
        </div>
      </div>

      <div className="bg-white rounded-2xl mt-8 shadow-sm border border-gray-100 flex flex-col max-w-sm mx-auto w-full overflow-hidden">
        <div
          onClick={() => navigate('/limit-reached')}
          className="flex items-center justify-between p-4 border-b border-[#A5C0DD]/40 cursor-pointer"
        >
          <div className="flex items-center">
            <img
              src={`${base}assets/icon-history.png`}
              alt="Focus History"
              className="w-6 h-6 mr-3"
            />
            <div className="font-bold text-[#1B2755]">Focus History</div>
          </div>
          <div className="text-xl text-gray-400">
          </div>
        </div>
        <div
          onClick={() => navigate('/points')}
          className="flex items-center justify-between p-4 cursor-pointer"
        >
          <div className="flex items-center">
            <img
              src={`${base}assets/icon-points.png`}
              alt="My Points"
              className="w-6 h-6 mr-3"
            />
            <div className="font-bold text-[#1B2755]">My Points</div>
          </div>
          <div className="text-xl text-gray-400">
          </div>
        </div>
      </div>

      <BottomNavigation activePage="profile" />
    </div>
  );
}

export default Profile;