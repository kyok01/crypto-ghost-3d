// RecoveryStory.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// いくつかの OpenZeppelin のコントラクトをインポート。
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


// utils ライブラリをインポートして文字列の処理を行う。
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Base64.solコントラクトからSVGとJSONをBase64に変換する関数をインポート。
import { Base64 } from "./libraries/Base64.sol";

// インポートした OpenZeppelin のコントラクトを継承。
// 継承したコントラクトのメソッドにアクセスできるようになる。
contract MintNft is ERC721URIStorage {
    using Strings for *;

    // OpenZeppelin が tokenIds を簡単に追跡するために提供するライブラリを呼び出す
    using Counters for Counters.Counter;

    // _tokenIdsを初期化（_tokenIds = 0）
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: #F8F5F5; font-family: 'Georgia, serif'; font-size: 24px; }</style><rect width='100%' height='100%' fill='#3FC0A1' /><text x='50%' y='50%' className='base' dominant-baseline='middle' text-anchor='middle'>";

    // NFT トークンの名前とそのシンボルを渡す。
    constructor() ERC721 ("GhostNFT", "GHOST") {
        console.log("Create GhostNFT");
    }

    // シードを生成する関数を作成。
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // ユーザーが NFT を取得するために実行する関数。
    function ghostNftMint(
        string memory _name,
        string memory _description,
        uint divNumHorizontal,
        uint divNumVertical,
        string[] memory baseVVector,
        string[] memory baseVnVector
        ) public {

        // 現在のtokenIdを取得。tokenIdは0から始まる。
        uint256 newItemId = _tokenIds.current();

        string memory finalSvg = baseSvg;
        console.log(finalSvg);

        string memory svgText;
        svgText = string.concat(Strings.toString(divNumHorizontal), "\n", Strings.toString(divNumVertical), "\n");
        for (uint i = 0; i < baseVnVector.length; i++) {
            svgText = string.concat(svgText, baseVVector[i], baseVnVector[i], "\n");
        }

        finalSvg = string(abi.encodePacked(finalSvg, svgText, "</text></svg>"));

        // NFTに出力されるテキストをターミナルに出力。
        console.log("\n----- SVG data -----");
        console.log(finalSvg);
        console.log("--------------------\n");


        // JSONファイルを所定の位置に取得し、base64としてエンコード。
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // NFTのタイトルを生成される言葉に設定。
                        _name,
                        '", "description":',
                        _description,
                        ', "image": "data:image/svg+xml;base64,',
                        //  data:image/svg+xml;base64 を追加し、SVG を base64 でエンコードした結果を追加。
                        // Base64.encode(bytes(_svg)),
                        finalSvg,
                        '"}'
                    )
                )
            )
        );

        // データの先頭に data:application/json;base64 を追加。
        // string memory tokenUri = string(
        //     abi.encodePacked("data:application/json;base64,", json)
        // );
        string memory tokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n----- Token URI ----");
        console.log(tokenUri);
        console.log("--------------------\n");

        // msg.sender を使って NFT を送信者に Mint。
        _safeMint(msg.sender, newItemId);

        // tokenURIを更新。
        _setTokenURI(newItemId, tokenUri);

        // NFTがいつ誰に作成されたかを確認。
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // 次の NFT が Mint されるときのカウンターをインクリメントする。
        _tokenIds.increment();
    }
}

