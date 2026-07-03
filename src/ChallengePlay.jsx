import { useState, useEffect, useRef, useContext } from 'react';
import { useNavigate } from 'react-router-dom';
import { AppContext } from './index.jsx';

function ChallengePlay() {
  const [selectedApps, setSelectedApps, userName, points, setPoints] = useContext(AppContext);
  const navigate = useNavigate();
  const base = import.meta.env.BASE_URL;
  
  const [gameCompleted, setGameCompleted] = useState(false);
  const [timeLeft, setTimeLeft] = useState(90);
  const [isGameActive, setIsGameActive] = useState(true);
  const [cards, setCards] = useState([]);
  const [openedCards, setOpenedCards] = useState([]);
  const [matchedCards, setMatchedCards] = useState([]);

  const timerRef = useRef(null);
  const openedCardCount = useRef(0);

  const icons = [
    `${base}assets/coin-icon.png`,
    `${base}assets/coin-icon.png`,
    `${base}assets/icon-usage.png`,
    `${base}assets/icon-usage.png`,
    `${base}assets/apple-icon.png`,
    `${base}assets/apple-icon.png`,
    `${base}assets/google-icon.png`,
    `${base}assets/google-icon.png`,
    `${base}assets/apple-icon.png`,
    `${base}assets/apple-icon.png`,
    `${base}assets/google-icon.png`,
    `${base}assets/google-icon.png`
  ];

  useEffect(() => {
    const shuffledCards = [...icons].sort(() => Math.random() - 0.5);
    setCards(shuffledCards);
  }, []);

  useEffect(() => {
    if (timeLeft <= 0 || !isGameActive) return;

    timerRef.current = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          clearInterval(timerRef.current);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [timeLeft, isGameActive]);

  useEffect(() => {
    if (matchedCards.length === 6) {
      handleGameCompletion();
    }
  }, [matchedCards]);

  const handleGameCompletion = () => {
    clearInterval(timerRef.current);
    setIsGameActive(false);
    setGameCompleted(true);
    setPoints(points + 10);
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const handleCardClick = (index) => {
    if (!isGameActive || openedCards.includes(index) || matchedCards.includes(index)) {
      return;
    }

    if (openedCardCount.current === 0) {
      setOpenedCards([index]);
      openedCardCount.current = 1;
    } else if (openedCardCount.current === 1) {
      const newOpenedCards = [...openedCards, index];
      setOpenedCards(newOpenedCards);
      openedCardCount.current = 2;

      if (cards[newOpenedCards[0]] === cards[newOpenedCards[1]]) {
        setMatchedCards([...matchedCards, newOpenedCards[0], newOpenedCards[1]]);
        setOpenedCards([]);
        openedCardCount.current = 0;
      } else {
        setTimeout(() => {
          setOpenedCards([]);
          openedCardCount.current = 0;
        }, 800);
      }
    }
  };

  return (
    <div className="min-h-screen bg-[#1B2755] text-white p-6">
      <div className="flex justify-between items-center mb-6">
        <button
          onClick={() => navigate('/challenge')}
          className="text-white text-xl"
        >
          ←
        </button>
        <h1 className="text-xl font-bold">Memory Match</h1>
        <div className="flex items-center gap-2">
          <img
            src={`${base}assets/coin-icon.png`}
            alt="Coins"
            className="w-4 h-4"
          />
          <span className="font-bold">{points}</span>
        </div>
      </div>

      <div className="border border-[#A5C0DD] rounded-full px-4 py-1.5 text-[#A5C0DD] flex items-center justify-center gap-2 mx-auto w-max">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M12 2a10 10 0 1 1 0 20 10 10 0 0 1 0-20z" />
          <path d="M12 6v6l4 2" />
        </svg>
        <span>01:{formatTime(timeLeft).padStart(5, '0')}</span>
      </div>

      <div className="grid grid-cols-3 gap-3 mt-8 max-w-sm mx-auto">
        {cards.map((icon, index) => (
          <div
            key={index}
            onClick={() => handleCardClick(index)}
            className={`aspect-[3/4] rounded-lg shadow-md cursor-pointer transition-all duration-300 ${
              openedCards.includes(index) || matchedCards.includes(index) 
                ? 'bg-white transform scale-105'
                : 'bg-[#204A94]'
              }`}
          >
            {(openedCards.includes(index) || matchedCards.includes(index)) && (
              <img
                src={icon}
                alt="Card icon"
                className="w-full h-full object-contain p-2"
              />
            )}
          </div>
        ))}
      </div>

      <div className="mt-auto pt-6">
        <button
          onClick={() => setIsGameActive(!isGameActive)}
          className="w-full max-w-sm mx-auto border border-[#A5C0DD] rounded-xl py-4 flex items-center justify-center gap-2 font-bold text-white mt-auto"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M6 2v6h12V2M6 14v6h12v-6M6 10v4h12v-4M6 6v4h12V6" />
          </svg>
          Pause
        </button>
      </div>

      {gameCompleted && (
        <div className="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50">
          <div className="bg-[#1B2755] rounded-2xl p-8 max-w-sm mx-auto text-center">
            <h2 className="text-2xl font-bold mb-4">Challenge Completed!</h2>
            <div className="mb-6">
              <img
                src={`${base}assets/mascot-cool.png`}
                alt="Mascot"
                className="w-24 mx-auto object-contain"
              />
            </div>
            <p className="text-gray-300 mb-6">
              Great job! You earned +10 points!
            </p>
            <button
              onClick={() => navigate('/challenge')}
              className="w-full bg-[#204A94] text-white font-bold py-4 rounded-xl"
            >
              Back to Challenge Menu
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

export default ChallengePlay;