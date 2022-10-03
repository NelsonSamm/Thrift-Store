import "./App.css";
import "bootstrap/dist/css/bootstrap.min.css";
import Navbar from "./components/Navbar";
import { useState, useEffect } from "react";

import Web3 from "web3";
import { newKitFromWeb3 } from "@celo/contractkit";
import BigNumber from "bignumber.js";
import IERC from "./contract/IERC.abi.json";
import Thrift from "./contract/Thrift.abi.json";
import AddProduct from "./components/AddProduct";
import Products from "./components/Products";

const ERC20_DECIMALS = 18;

const contractAddress = "0x7146A7ab6fF21B39D4eb6Ad8914A07634e7a5bbC";
const cUSDContractAddress = "0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1";

function App() {
	const [contract, setcontract] = useState(null);
	const [address, setAddress] = useState(null);
	const [kit, setKit] = useState(null);
	const [cUSDBalance, setcUSDBalance] = useState(0);
	const [products, setProducts] = useState([]);

	const connectToWallet = async () => {
		if (window.celo) {
			try {
				await window.celo.enable();
				const web3 = new Web3(window.celo);
				let kit = newKitFromWeb3(web3);

				const accounts = await kit.web3.eth.getAccounts();
				const user_address = accounts[0];

				kit.defaultAccount = user_address;

				await setAddress(user_address);
				await setKit(kit);
			} catch (error) {
				console.log(error);
			}
		} else {
			console.log("Error Occurred");
		}
	};

	useEffect(() => {
		connectToWallet();
	}, []);

	useEffect(() => {
		if (kit && address) {
			getBalance();
		}
	}, [kit, address]);

	useEffect(() => {
		if (contract) {
			getProducts();
		}
	}, [contract]);

	const getBalance = async () => {
		try {
			const balance = await kit.getTotalBalance(address);
			const USDBalance = balance.cUSD
				.shiftedBy(-ERC20_DECIMALS)
				.toFixed(2);
			const contract = new kit.web3.eth.Contract(
				Thrift,
				contractAddress
			);
			setcontract(contract);
			setcUSDBalance(USDBalance);
		} catch (error) {
			console.log(error);
		}
	};

	const getProducts = async () => {
		const thriftsLength = await contract.methods.gethriftsLength().call();
		console.log(thriftsLength);
		const _tit = [];
		for (let index = 0; index < thriftsLength; index++) {
			let _products = new Promise(async (resolve, reject) => {
				let product = await contract.methods.getProduct(index).call();

				resolve({
					index: index,
					creator: product[0],
					url: product[1],
					location: product[2],
					serviceOption: product[3],
					phone: product[4],
					price:product[5]
				});
			});
			_tit.push(_products);
		}
		const _products = await Promise.all(_tit);
		setProducts(_products);
		console.log(products);
	};

	const addProduct = async (_url, _location, _serviceOption, _phone, price) => {
		const _price = new BigNumber(price)
			.shiftedBy(ERC20_DECIMALS)
			.toString();
		try {
			await contract.methods
				.addProduct(_url, _location, _serviceOption, _phone, _price)
				.send({ from: address });
			getProducts();
		} catch (error) {
			console.log(error);
		}
	
	 
 
	const buyProduct = async (_index) => {
		try {
			const cUSDContract = new kit.web3.eth.Contract(
				IERC,
				cUSDContractAddress
			);

			await cUSDContract.methods
				.approve(contractAddress, products[_index].price)
				.send({ from: address });
			await contract.methods.buyProduct(_index).send({ from: address });
			getProducts();
			getBalance();
		} catch (error) {
			console.log(error);
		}
	};

	return (
		
		
			<div>
				<Navbar balance={cUSDBalance} />

				<Products
					products={products}
					buyProduct={buyProduct}
				
				/>
				<AddProduct addProduct={addProduct} />
			</div>
	
	
);
	}
}

export default App;