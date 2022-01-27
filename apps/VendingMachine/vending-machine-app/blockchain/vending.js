import Web3 from "web3"

const provider = new Web3.providers.HttpProvider(
  "https://rinkeby.infura.io/v3/7b5c4bdddba84bd490075f74766ac66e"
)

const web3 = new Web3(provider)

// abi copy / pasted from './build/blockchain_contracts_VendingMachine_sol_VendingMachine.abi'
const vendingMachineABI = [{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"donutBalances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getVendingMachineBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"purchase","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"restock","outputs":[],"stateMutability":"nonpayable","type":"function"}]

const vmContract = new web3.eth.Contract(
    vendingMachineABI,
    "0x3BBF4E0D96e02AD19011723bf0748926250DF9A6"
  )

export default vmContract