import React, { useState } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Home from '../pages/Home';
import '../index.css';

declare global {
    interface Window {
        ethereum: any;
    }
}

const App: React.FC = () => {
    const [account, setAccount] = useState<string>('');

    const connectWallet = async () => {
        if (typeof window.ethereum !== 'undefined') {
            try {
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                setAccount(accounts[0]);
            } catch (error) {
                console.error('Error connecting to wallet:', error);
            }
        } else {
            alert('Please install MetaMask or another Web3 wallet!');
        }
    };

    return (
        <BrowserRouter>
            <div className="min-h-screen bg-gray-900">
                <div className="container mx-auto px-4 py-2">
                    <div className="flex justify-end mb-4">
                        {account ? (
                            <p className="text-white">
                                Connected: {account.slice(0, 6)}...{account.slice(-4)}
                            </p>
                        ) : (
                            <button 
                                onClick={connectWallet}
                                className="bg-yellow-400 hover:bg-yellow-500 text-black px-4 py-2 rounded-lg"
                            >
                                Connect Wallet
                            </button>
                        )}
                    </div>
                    <Routes>
                        <Route path="/" element={<Home />} />
                    </Routes>
                </div>
            </div>
        </BrowserRouter>
    );
};

export default App;