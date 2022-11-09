import React, { useEffect, useState } from "react";
import { ethers } from "ethers";

import './App.css';
import abi from "./utils/DecodeObjTest.json";

function App() {
  const contractAddress = "0x50df830663D60d8f89CF5e4Da95ebAe716Db0E1F";

  const [allGhost, setAllGhost] = useState("");

  const [currentAccount, setCurrentAccount] = useState("");

  const [name, setName] = React.useState("")

  const [obj, setObj] = React.useState("")

  // 表示順を指定
  const [description, setDescription] = React.useState("")

  const nameSet = e => setName(e.target.value);

  const descriptionSet = e => setDescription(e.target.value);

  // ABIを参照
  const contractABI = abi.abi;

  // 全ての投稿を取得
  const getAllGhost = async () => {
    const { ethereum } = window;

    try {
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const Contract = new ethers.Contract(
          contractAddress,
          contractABI,
          signer
          );
          // コントラクトからgetAllPostメソッドを呼び出す
          const ghosts = await Contract.getAllPost();
          const ghostsCleaned = ghosts.map((ghost) => {
            return {
              name: ghost.name,
              description: ghost.description,
              material: ghost.material,
              ghostId: ghost.ghostId,
              vectorDataIndex: ghost.vectorDataIndex,
            };
          });

          // React Stateにデータを格納
          setAllGhost(ghostsCleaned);
        } else {
          console.log("Ethereum object doesn't exist!");
        }
      } catch (error) {
        console.log(error);
      }
    };

    useEffect(() => {
      let ghostContract;

      const onNewGhost = (name, description, material, ghostId, vectorDataIndex) => {
        console.log("NewGhost", name, description, material, ghostId, vectorDataIndex);
        setAllGhost((prevState) => [
          ...prevState,
          {
            name: name,
            description: description,
            material: material,
            ghostId: ghostId,
            vectorDataIndex: vectorDataIndex,
          },
        ]);
      };

      // NewPostイベントがコントラクトから発信されたときに、情報を受け取る
      if (window.ethereum) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();

        ghostContract = new ethers.Contract(
          contractAddress,
          contractABI,
          signer
          );
          ghostContract.on("NewGhost", onNewGhost);
        }
        // メモリリークを防ぐために、NewPostのイベントを解除
        return () => {
          if (ghostContract) {
            ghostContract.off("NewGhost", onNewGhost);
          }
        };
      }, []);

      // window.ethereumにアクセスできることを確認
      const checkIfWalletIsConnected = async () => {
        try {
          const { ethereum } = window;
          if (!ethereum) {
            console.log("Get your Metamask ready!");
            return;
          } else {
            console.log("We have the ethereum object", ethereum);
          }
          // ユーザーのウォレットへのアクセスが許可されているかどうかを確認
          // アカウントがあれば一番目のアドレスを表示。
          const accounts = await ethereum.request({ method: "eth_accounts" });
          if (accounts.length !== 0) {
            const account = accounts[0];
            console.log("Found an authorized account:", account);
            setCurrentAccount(account);
            getAllGhost();
          } else {
            console.log("No authorized account found");
          }
        } catch (error) {
          console.log(error);
        }
      };

      // connectWalletメソッドを実装
      const connectWallet = async () => {
        try {
          const { ethereum } = window;
          if (!ethereum) {
            alert("Get MetaMask!");
            return;
          }
      const accounts = await ethereum.request({
        method: "eth_requestAccounts",
      });
      console.log("Connected: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };

  const writeGhost = async () => {
    try {
      const { ethereum } = window;
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();

        const writeGhostContract = new ethers.Contract(
          contractAddress,
          contractABI,
          signer
        );

        await writeGhostContract.writeGhost(name, description, "material", 12);

        setName("")
        setDescription("")
      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error);
    }
  };

  // いいね
  const readGhost = async (ghostId, divNumHorizontal) => {
    try {
      const { ethereum } = window;
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();

        const readGhostContract = new ethers.Contract(
          contractAddress,
          contractABI,
          signer
        );

        const obj = await readGhostContract.goodPost(ghostId, divNumHorizontal);
        setObj(obj)

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error);
    }
  };

  // WEBページロード時に実行。
  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);

  return (
    <div className="App">
        <div>{/* ウォレットに接続されている確認 */}
          {!currentAccount && (
            <button className="waveButton px-3 py-2 mt-2 text-lg font-medium rounded-sm hover:bg-gray-300" onClick={connectWallet}>
              Connect Wallet
            </button>
          )}
          {currentAccount && (
            <button className="waveButton px-3 py-2 mt-2 text-lg font-medium rounded-sm hover:bg-gray-300" onClick={connectWallet}>
              { currentAccount.substr(0, 8) }...
            </button>
          )}
        </div>
        <section className="text-gray-600 body-font">
        <div className="container px-5 py-24 mx-auto">
          <div className="flex flex-wrap w-full mb-20">
            <div className="lg:w-1/2 w-full mb-6 lg:mb-0">
              <h1 className="sm:text-3xl text-2xl font-medium title-font mb-2 text-gray-900">Pitchfork Kickstarter Taxidermy</h1>
              <div className="h-1 w-20 bg-indigo-500 rounded" />
            </div>
            <p className="lg:w-1/2 w-full leading-relaxed text-gray-500">Whatever cardigan tote bag tumblr hexagon brooklyn asymmetrical gentrify, subway tile poke farm-to-table. Franzen you probably haven't heard of them man bun deep jianbing selfies heirloom prism food truck ugh squid celiac humblebrag.</p>
          </div>
          <div className="flex flex-wrap -m-4">
            <div className="xl:w-1/4 md:w-1/2 p-4">
              <div className="bg-gray-100 p-6 rounded-lg">
                <img className="h-40 rounded w-full object-cover object-center mb-6" src="https://dummyimage.com/720x400" alt="content" />
                <h3 className="tracking-widest text-indigo-500 text-xs font-medium title-font">SUBTITLE</h3>
                <h2 className="text-lg text-gray-900 font-medium title-font mb-4">Chichen Itza</h2>
                <p className="leading-relaxed text-base">Fingerstache flexitarian street art 8-bit waistcoat. Distillery hexagon disrupt edison bulbche.</p>
              </div>
            </div>
            <div className="xl:w-1/4 md:w-1/2 p-4">
              <div className="bg-gray-100 p-6 rounded-lg">
                <img className="h-40 rounded w-full object-cover object-center mb-6" src="https://dummyimage.com/721x401" alt="content" />
                <h3 className="tracking-widest text-indigo-500 text-xs font-medium title-font">SUBTITLE</h3>
                <h2 className="text-lg text-gray-900 font-medium title-font mb-4">Colosseum Roma</h2>
                <p className="leading-relaxed text-base">Fingerstache flexitarian street art 8-bit waistcoat. Distillery hexagon disrupt edison bulbche.</p>
              </div>
            </div>
            <div className="xl:w-1/4 md:w-1/2 p-4">
              <div className="bg-gray-100 p-6 rounded-lg">
                <img className="h-40 rounded w-full object-cover object-center mb-6" src="https://dummyimage.com/722x402" alt="content" />
                <h3 className="tracking-widest text-indigo-500 text-xs font-medium title-font">SUBTITLE</h3>
                <h2 className="text-lg text-gray-900 font-medium title-font mb-4">Great Pyramid of Giza</h2>
                <p className="leading-relaxed text-base">Fingerstache flexitarian street art 8-bit waistcoat. Distillery hexagon disrupt edison bulbche.</p>
              </div>
            </div>
            <div className="xl:w-1/4 md:w-1/2 p-4">
              <div className="bg-gray-100 p-6 rounded-lg">
                <img className="h-40 rounded w-full object-cover object-center mb-6" src="https://dummyimage.com/723x403" alt="content" />
                <h3 className="tracking-widest text-indigo-500 text-xs font-medium title-font">SUBTITLE</h3>
                <h2 className="text-lg text-gray-900 font-medium title-font mb-4">San Francisco</h2>
                <p className="leading-relaxed text-base">Fingerstache flexitarian street art 8-bit waistcoat. Distillery hexagon disrupt edison bulbche.</p>
              </div>
            </div>
          </div>
        </div>
      </section>

    </div>
  );
}

export default App;
