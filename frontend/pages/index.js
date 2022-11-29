import Head from "next/head";
import Image from "next/image";

export default function Home() {
  return (
    <div className="p-10">
      <div id="nav-bar" className="flex items-center">
        <div className="flex">
          <div>Portfolio</div>
          <div className="ml-5">Crypto ID</div>
          <div className="ml-5">Networks Connected</div>
        </div>
        <div className="flex absolute right-10">
          <div className="mr-5">INR</div>
          <div>Points</div>
        </div>
      </div>
      <div className="mt-10">
        <div className="">Networth</div>
        <div className="text-xl font-bold">$7,092.66</div>
      </div>
      <div className="mt-10 p-5" style={{ background: "white" }}>
        <div className="flex items-center">
          <div className="">Assets</div>
          <div className="flex absolute right-10">
            <div className="pr-5">Tokens</div>
            <div className="pr-5">NFTs</div>
            <div className="pr-5">Transactions</div>
          </div>
        </div>

        <div className="mt-10">
          <div className="border-b-2">
            <div className="flex px-5 pb-3">
              <div className="w-1/2">Token</div>
              <div className="w-1/3">Portfolio</div>
              <div className="w-1/3">Price</div>
              <div className="w-1/3">Balance</div>
            </div>
          </div>
          <div className="border-b-2 mt-5">
            <div className="flex px-5 pb-3">
              <div className="w-1/2">USDC</div>
              <div className="w-1/3">85.03%</div>
              <div className="w-1/3">$81.75</div>
              <div className="w-1/3">$6,030.77</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
