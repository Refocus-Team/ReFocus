import { useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppContext, BottomNavigation } from './index.jsx';

function Points() {
  const [selectedApps, setSelectedApps, userName, points, setPoints] = useContext(AppContext);
  const navigate = useNavigate();
  const base = import.meta.env.BASE_URL;

  const transactions = [
    { id: 1, date: 'Today', description: 'Completed Memory Match', points: '+10', type: 'earned' },
    { id: 2, date: 'Yesterday', description: 'Daily login bonus', points: '+5', type: 'earned' },
    { id: 3, date: '2 days ago', description: 'Focus streak maintained', points: '+15', type: 'earned' },
    { id: 4, date: '3 days ago', description: 'Challenge completed', points: '+20', type: 'earned' },
    { id: 5, date: '4 days ago', description: 'Weekly bonus', points: '+25', type: 'earned' },
  ];

  const withdrawalOptions = [
    { name: 'Voucher', min: 100, icon: `${base}assets/icon-points.png` },
    { name: 'PayPal', min: 500, icon: `${base}assets/icon-points.png` },
    { name: 'Bank Transfer', min: 1000, icon: `${base}assets/icon-points.png` },
  ];

  return (
    <div className="min-h-screen bg-[#F5F7FA] pb-28">
      <div className="p-6">
        <div className="flex justify-between items-center mb-6">
          <button onClick={() => navigate('/profile')} className="text-2xl">←</button>
          <h1 className="text-xl font-bold text-[#1B2755]">My Points</h1>
          <div></div>
        </div>

        <div className="bg-gradient-to-r from-[#1B2755] to-[#204A94] rounded-2xl p-6 text-white mb-6">
          <div className="text-center">
            <div className="text-sm opacity-80 mb-2">Your Points Balance</div>
            <div className="text-5xl font-bold">{points}</div>
            <div className="text-sm opacity-80 mt-2">Total Points Earned</div>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-3 mb-6">
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-[#204A94]">240</div>
            <div className="text-xs text-gray-500">This Week</div>
          </div>
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-[#204A94]">850</div>
            <div className="text-xs text-gray-500">This Month</div>
          </div>
          <div className="bg-white rounded-xl p-4 text-center shadow-sm">
            <div className="text-2xl font-bold text-[#204A94]">2400</div>
            <div className="text-xs text-gray-500">All Time</div>
          </div>
        </div>

        <div className="mb-6">
          <h2 className="text-lg font-bold text-[#1B2755] mb-4">Withdrawal Options</h2>
          <div className="grid grid-cols-3 gap-3">
            {withdrawalOptions.map((option, index) => (
              <div
                key={index}
                className={`bg-white rounded-xl p-4 text-center shadow-sm border-2 ${
                  points >= option.min ? 'border-green-500' : 'border-gray-200 opacity-60'
                }`}
              >
                <img
                  src={option.icon}
                  alt={option.name}
                  className="w-8 h-8 mx-auto mb-2"
                />
                <div className="text-sm font-bold text-[#1B2755]">{option.name}</div>
                <div className="text-xs text-gray-500 mt-1">Min: {option.min} pts</div>
                <button
                  disabled={points < option.min}
                  className={`mt-2 text-xs font-bold py-1 px-3 rounded-lg ${
                    points >= option.min
                      ? 'bg-[#204A94] text-white'
                      : 'bg-gray-200 text-gray-400'
                  }`}
                >
                  Withdraw
                </button>
              </div>
            ))}
          </div>
        </div>

        <div>
          <h2 className="text-lg font-bold text-[#1B2755] mb-4">Transaction History</h2>
          <div className="space-y-3">
            {transactions.map((transaction) => (
              <div
                key={transaction.id}
                className="bg-white rounded-xl p-4 flex justify-between items-center shadow-sm border border-gray-100"
              >
                <div>
                  <div className="font-medium text-[#1B2755]">{transaction.description}</div>
                  <div className="text-xs text-gray-500">{transaction.date}</div>
                </div>
                <div className={`font-bold ${
                  transaction.type === 'earned' ? 'text-green-600' : 'text-red-600'
                }`}>
                  {transaction.points}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <BottomNavigation activePage="profile" />
    </div>
  );
}

export default Points;