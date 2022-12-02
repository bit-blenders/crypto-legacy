let account;

export async function connectWallet() {
    // react usage
    // const [wallet, setWallet] = useState("");

    if(typeof window.ethereum !== 'undefined') {
        // type address[]
        [ account ] = await window.ethereum.request({ method: 'eth_requestAccounts' });
        // setWallet(account);
        console.log(account);
    }
}

export function fetchTokens(address) { // address => wallet address
    const url = '';
    // fetch data form covalent api
    // re-structure data for frontend requirement
    /* 
    * data => [ tokens ]
    * data: [
        {
            name: '',
            symbol: '',
            address: '',
            balance: 10.00, // fetchTokenBalance(address)
        }
    ]
    */
}

export async function fetchTokenBalance(address) { // address => token contract address
    const [ account ] = await window.ethereum.request(
        { method: 'eth_requestAccounts' }
    );
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const token = new ethers.Contract(address, Token.abi, provider);
    let balance = await token.balance(account);
    balance = parseFloat(ethers.uitls.fromatEther(balance).toString());
    return balance;
}