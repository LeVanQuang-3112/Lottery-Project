import { createContext, useState } from "react";

export const GlobalState = createContext()

export const DataProvider = ({ children }) => {
    const [token, setToken] = useState(false)
    const [web3, setWeb3] = useState()
    const [address, setAddress] = useState()
    const [lcContract, setLcContract] = useState()
    const [lotteryPot, setLotteryPot] = useState()
    const [lotteryPlayers, setPlayers] = useState([])
    const [lotteryHistory, setLotteryHistory] = useState([])
    const [lotteryId, setLotteryId] = useState()
    const [error, setError] = useState('')
    const [successMsg, setSuccessMsg] = useState('')
    const [inputPrice, setInputPrice] = useState(0)
    const [loading, setLoading] = useState(false)
    const statedData = {
        store: [token, setToken, web3, setWeb3, address, setAddress, lcContract, setLcContract, lotteryId,
            setLotteryId, lotteryPot, setLotteryPot, lotteryPlayers, setPlayers, lotteryHistory, setLotteryHistory,
            error, setError, successMsg, setSuccessMsg, inputPrice, setInputPrice, loading, setLoading]

    }

    return (
        <GlobalState.Provider value={statedData}>
            {children}
        </GlobalState.Provider>
    )
}