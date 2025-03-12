import React, { useState } from 'react';
import { ethers } from 'ethers';

interface Token {
    symbol: string;
    icon: string;
}

const Home: React.FC = () => {
    const [sourceCoin, setSourceCoin] = useState<string>('ETH');
    const [targetCoin, setTargetCoin] = useState<string>('ETH');
    const [sourceAmount, setSourceAmount] = useState<string>('0');
    const [targetAmount, setTargetAmount] = useState<string>('0');
    const [sourceChain, setSourceChain] = useState<string>('ETH');
    const [targetChain, setTargetChain] = useState<string>('Aptos');

    const tokens: Token[] = [
        { symbol: 'ETH', icon: '🔷' },
        { symbol: 'USDT', icon: '💵' },
        { symbol: 'USDC', icon: '💰' },
    ];

    const chains = ['ETH', 'Aptos'];

    const handleConnect = () => {
        // Implement wallet connection logic here
        console.log('Connecting wallet...');
    };

    const handleSwap = () => {
        // Implement swap logic here
        console.log('Swapping tokens...');
    };

    return (
        <div className="flex justify-center items-center min-h-screen bg-gray-900 text-white p-4">
            <div className="w-full max-w-md p-6 rounded-lg bg-gray-800 shadow-xl">
                <div className="space-y-6">
                    {/* You Pay Section */}
                    <div>
                        <div className="flex justify-between mb-2">
                            <span>You pay</span>
                            <span>Balance: 0 {sourceCoin}</span>
                        </div>
                        <div className="flex items-center p-4 rounded-lg bg-gray-900">
                            <div className="flex-1">
                                <select 
                                    className="w-full bg-transparent outline-none"
                                    value={sourceCoin}
                                    onChange={(e) => setSourceCoin(e.target.value)}
                                >
                                    {tokens.map((token) => (
                                        <option key={token.symbol} value={token.symbol}>
                                            {token.icon} {token.symbol}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <input
                                type="number"
                                className="w-1/2 bg-transparent text-right outline-none"
                                value={sourceAmount}
                                onChange={(e) => setSourceAmount(e.target.value)}
                                placeholder="0"
                            />
                        </div>
                    </div>

                    {/* Swap Icon */}
                    <div className="flex justify-center">
                        <button className="p-2 rounded-full bg-gray-700 hover:bg-gray-600">
                            ⇅
                        </button>
                    </div>

                    {/* You Receive Section */}
                    <div>
                        <div className="flex justify-between mb-2">
                            <span>You receive</span>
                            <span>Balance: 0 {targetCoin}</span>
                        </div>
                        <div className="flex items-center p-4 rounded-lg bg-gray-900">
                            <div className="flex-1">
                                <select 
                                    className="w-full bg-transparent outline-none"
                                    value={targetCoin}
                                    onChange={(e) => setTargetCoin(e.target.value)}
                                >
                                    {tokens.map((token) => (
                                        <option key={token.symbol} value={token.symbol}>
                                            {token.icon} {token.symbol}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <input
                                type="number"
                                className="w-1/2 bg-transparent text-right outline-none"
                                value={targetAmount}
                                onChange={(e) => setTargetAmount(e.target.value)}
                                placeholder="0"
                            />
                        </div>
                    </div>

                    {/* Points and ETA */}
                    <div className="flex justify-between items-center">
                        <span className="text-yellow-400">+ 0 POINTS</span>
                        <span>ETA: &lt; 2.5 min</span>
                    </div>

                    {/* Chain Selection */}
                    <div className="p-4 rounded-lg bg-gray-900">
                        <div className="flex items-center justify-between">
                            <span>Trade and Send to Another Address</span>
                            <span>Routing ▼</span>
                        </div>
                        <div className="flex justify-between">
                            <div className="flex-1">
                                <select 
                                    className="w-full bg-transparent outline-none"
                                    value={sourceChain}
                                    onChange={(e) => setSourceChain(e.target.value)}
                                >
                                    {chains.map((chain) => (
                                        <option key={chain} value={chain}>
                                            {chain}
                                        </option>
                                    ))}
                                </select>
                            </div>
                            <div className="flex-1">
                                <select 
                                    className="w-full bg-transparent outline-none"
                                    value={targetChain}
                                    onChange={(e) => setTargetChain(e.target.value)}
                                >
                                    {chains.map((chain) => (
                                        <option key={chain} value={chain}>
                                            {chain}
                                        </option>
                                    ))}
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* Connect Wallet Button */}
                    <button
                        onClick={handleConnect}
                        className="w-full py-3 bg-yellow-400 hover:bg-yellow-500 text-black rounded-lg font-medium"
                    >
                        Connect wallet
                    </button>
                </div>
            </div>
        </div>
    );
};

export default Home;