// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.12;

// import "./Trigonometry.sol";
// import { Base64 } from "./libraries/Base64.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "hardhat/console.sol";

// contract DecodeObj {
//     using Trigonometry for uint256;
//     using Strings for *;

//     struct ObjData {
//         uint256 divNumHorizontal;
//         uint256 divNumVertical;
//         uint256[] baseVVector; // vの配列
//         uint256[] baseVnVector; // vnの配列
//     }

//     struct GhostData {
//         string name;
//         uint256 id;
//         uint256 divNumHorizontal;
//         uint256 objDataIndex;
//     }

//     ObjData[] public objData;

//     mapping(uint256 => uint256) ghostIdToGhostData;
//     mapping(uint256 => uint256) divNumHorizontalToObjDataId;

//     uint256 objDataId = 1;

//     function getSinCos() public pure returns (int256, int256) {
//         uint256 angle = 30; // degree

//         int256 sin_num = (((angle * 0x4000) / 360).sin() * 100000) / 0x7fff;
//         int256 cos_num = (((angle * 0x4000) / 360).cos() * 100000) / 0x7fff;

//         return (sin_num, cos_num);
//     }

//     function createBaseObjVector(int256 xVector, int256 yVector)
//         public
//         pure
//         returns (int256, int256)
//     {
//         int256 sinNum;
//         int256 cosNum;
//         (sinNum, cosNum) = getSinCos();
//         int256 nextX = cosNum * xVector + sinNum * yVector * -1;
//         int256 nextY = sinNum * xVector + cosNum * yVector;

//         return (nextX, nextY);
//     }

//     function createVVector(
//         string[] memory vectorBaseArray,
//         string memory vector
//     ) public pure returns (string memory, string memory) {
//         // x軸マイナス
//         // 左上の箇所のため、x軸の値が0になる。
//         vector = string.concat(
//             vector,
//             "v -0.",
//             vectorBaseArray[2],
//             " 0.",
//             vectorBaseArray[1],
//             " 0.",
//             vectorBaseArray[0],
//             "\n"
//         );
//         string memory vectorZInversion = string.concat(
//             "v -0.",
//             vectorBaseArray[2],
//             " -0.",
//             vectorBaseArray[1],
//             " 0.",
//             vectorBaseArray[0],
//             "\n"
//         );

//         for (uint256 i = 2; i > 0; i--) {
//             vector = string.concat(
//                 vector,
//                 "v -0.",
//                 vectorBaseArray[i * 3],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//             vectorZInversion = string.concat(
//                 vectorZInversion,
//                 "v -0.",
//                 vectorBaseArray[i * 3],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//         }

//         for (uint256 i = 0; i < 3; i++) {
//             if (
//                 keccak256(abi.encodePacked(vectorBaseArray[i * 3 + 2])) ==
//                 keccak256(abi.encodePacked("0.0"))
//             ) {
//                 vector = string.concat(
//                     vector,
//                     "v -0.",
//                     vectorBaseArray[i * 3],
//                     " 0.",
//                     vectorBaseArray[i * 3 + 1],
//                     " 0.",
//                     vectorBaseArray[i * 3 + 2],
//                     "\n"
//                 );
//                 vectorZInversion = string.concat(
//                     vectorZInversion,
//                     "v -0.",
//                     vectorBaseArray[i * 3],
//                     " -0.",
//                     vectorBaseArray[i * 3 + 1],
//                     " 0.",
//                     vectorBaseArray[i * 3 + 2],
//                     "\n"
//                 );
//             } else {
//                 vector = string.concat(
//                     vector,
//                     "v -0.",
//                     vectorBaseArray[i * 3],
//                     " 0.",
//                     vectorBaseArray[i * 3 + 1],
//                     " 0.",
//                     vectorBaseArray[i * 3 + 2],
//                     "\n"
//                 );
//                 vectorZInversion = string.concat(
//                     vectorZInversion,
//                     "v -0.",
//                     vectorBaseArray[i * 3],
//                     " -0.",
//                     vectorBaseArray[i * 3 + 1],
//                     " -0.",
//                     vectorBaseArray[i * 3 + 2],
//                     "\n"
//                 );
//             }
//         }

//         vector = string.concat(
//             vector,
//             "v 0.",
//             vectorBaseArray[2],
//             " 0.",
//             vectorBaseArray[1],
//             " -0.",
//             vectorBaseArray[0],
//             "\n"
//         );
//         vectorZInversion = string.concat(
//             vectorZInversion,
//             "v 0.",
//             vectorBaseArray[2],
//             " -0.",
//             vectorBaseArray[1],
//             " -0.",
//             vectorBaseArray[0],
//             "\n"
//         );

//         for (uint256 i = 2; i > 0; i--) {
//             vector = string.concat(
//                 vector,
//                 "v 0.",
//                 vectorBaseArray[i * 3],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//             vectorZInversion = string.concat(
//                 vectorZInversion,
//                 "v 0.",
//                 vectorBaseArray[i * 3],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//         }

//         return (vector, vectorZInversion);
//     }

//     function createVnVector(
//         string[] memory vectorBaseArray,
//         string memory vector
//     ) public pure returns (string memory, string memory) {
//         string memory vectorZInversion;
//         for (uint256 i = 0; i < 3; i++) {
//             vector = string.concat(
//                 vector,
//                 "vn -0.",
//                 vectorBaseArray[i * 3],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//             vectorZInversion = string.concat(
//                 "vn -0.",
//                 vectorBaseArray[i * 3],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//         }
//         for (uint256 i = 0; i < 3; i++) {
//             vector = string.concat(
//                 vector,
//                 "vn -0.",
//                 vectorBaseArray[i * 3],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//             vectorZInversion = string.concat(
//                 vectorZInversion,
//                 "vn -0.",
//                 vectorBaseArray[i * 3],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//         }
//         for (uint256 i = 0; i < 3; i++) {
//             vector = string.concat(
//                 vector,
//                 "vn 0.",
//                 vectorBaseArray[i * 3],
//                 " 0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//             vectorZInversion = string.concat(
//                 vectorZInversion,
//                 "vn 0.",
//                 vectorBaseArray[i * 3],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 1],
//                 " -0.",
//                 vectorBaseArray[i * 3 + 2],
//                 "\n"
//             );
//         }

//         return (vector, vectorZInversion);
//     }

//     function createF(uint256 _divNumHorizontal, uint256 _divNum)
//         public
//         pure
//         returns (string memory)
//     {
//         string memory fMesh;
//         for (uint256 index = 1; index <= _divNum; index++) {
//             string memory indexString = Strings.toString(index);
//             if (index < _divNumHorizontal) {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " 1/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             } else if (index == _divNumHorizontal) {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " 1/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - 10),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             } else if (index == _divNum) {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index - _divNumHorizontal * 2 + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " 62/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - _divNumHorizontal + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             } else if (index >= _divNum - _divNumHorizontal + 1) {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index - _divNumHorizontal + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " 62/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - _divNumHorizontal + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             } else if (index % _divNumHorizontal == 0) {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index - _divNumHorizontal * 2 + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - _divNumHorizontal + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString
//                 );
//                 fMesh = string.concat(
//                     fMesh,
//                     " ",
//                     Strings.toString(index + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - _divNumHorizontal + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             } else {
//                 fMesh = string.concat(
//                     fMesh,
//                     "f ",
//                     Strings.toString(index - _divNumHorizontal + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index + 2),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString
//                 );
//                 fMesh = string.concat(
//                     fMesh,
//                     " ",
//                     Strings.toString(index + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     " ",
//                     Strings.toString(index - _divNumHorizontal + 1),
//                     "/",
//                     indexString,
//                     "/",
//                     indexString,
//                     "\n"
//                 );
//             }
//         }

//         return fMesh;
//     }

//     function createVector(
//         string memory _vectorKind,
//         uint256 divNumHorizontal,
//         uint256[] memory baseVVector
//     ) public view returns (string memory) {
//         string memory vector;
//         string memory allZInversionVector;
//         for (uint256 i = 0; i < divNumHorizontal / 2; i++) {
//             console.log(unicode"for文開始");
//             string memory stringVectorX = Strings.toString(
//                 uint256(baseVVector[i])
//             );
//             string memory stringVectorY = Strings.toString(
//                 uint256(baseVVector[i + 1])
//             );
//             string memory stringVectorZ = Strings.toString(
//                 uint256(baseVVector[i + 2])
//             );

//             string[] memory baseVectorArray = new string[](9);
//             baseVectorArray[0] = stringVectorX;
//             baseVectorArray[1] = stringVectorZ;
//             baseVectorArray[2] = stringVectorY;

//             vector = string.concat(
//                 _vectorKind,
//                 " 0.",
//                 stringVectorX,
//                 " 0.",
//                 stringVectorZ,
//                 " 0.",
//                 stringVectorY,
//                 "\n"
//             ); // objテキストとして最後に返す文字列
//             string memory vectorZInversion = string.concat(
//                 _vectorKind,
//                 " 0.",
//                 stringVectorX,
//                 " -0.",
//                 stringVectorZ,
//                 " 0.",
//                 stringVectorY,
//                 "\n"
//             );

//             int256 nextVectorX = int256(baseVVector[0]);
//             int256 nextVectorY = int256(baseVVector[1]);
//             for (uint256 _i = 0; _i < divNumHorizontal / 2 - 1; _i++) {
//                 console.log(unicode"for文の中のfor文開始");
//                 (nextVectorX, nextVectorY) = createBaseObjVector(
//                     nextVectorX,
//                     nextVectorY
//                 );
//                 baseVectorArray[_i * 3 + 3] = Strings.toString(
//                     uint256(nextVectorX)
//                 );
//                 baseVectorArray[_i * 3 + 4] = stringVectorZ;
//                 baseVectorArray[_i * 3 + 5] = Strings.toString(
//                     uint256(nextVectorY)
//                 );

//                 stringVectorX = Strings.toString(uint256(nextVectorX));
//                 stringVectorY = Strings.toString(uint256(nextVectorY));

//                 vector = string.concat(
//                     vector,
//                     _vectorKind,
//                     " 0.",
//                     stringVectorX,
//                     " 0.",
//                     stringVectorZ,
//                     " 0.",
//                     stringVectorY,
//                     "\n"
//                 );
//                 vectorZInversion = string.concat(
//                     vectorZInversion,
//                     _vectorKind,
//                     " 0.",
//                     stringVectorX,
//                     " -0.",
//                     stringVectorZ,
//                     " 0.",
//                     stringVectorY,
//                     "\n"
//                 );
//                 console.log(vector);
//                 console.log(vectorZInversion);
//                 console.log(unicode"for文の中のfor文終了");
//             }
//             allZInversionVector = vectorZInversion;

//             if (
//                 keccak256(abi.encodePacked(_vectorKind)) ==
//                 keccak256(abi.encodePacked("v"))
//             ) {
//                 console.log(unicode"createVVector開始");
//                 (vector, vectorZInversion) = createVVector(
//                     baseVectorArray,
//                     vector
//                 );
//                 allZInversionVector = string.concat(
//                     vectorZInversion,
//                     allZInversionVector
//                 );
//             } else {
//                 (vector, vectorZInversion) = createVnVector(
//                     baseVectorArray,
//                     vector
//                 );
//                 allZInversionVector = string.concat(
//                     vectorZInversion,
//                     allZInversionVector
//                 );
//             }
//         }

//         vector = string.concat(vector, allZInversionVector);

//         return vector;
//     }

//     function createObjFile(uint256 _divNumHorizontal)
//         public
//         view
//         returns (string memory)
//     {
//         require(
//             divNumHorizontalToObjDataId[_divNumHorizontal] > 0,
//             "The specified number of divisions is not registered."
//         );
//         uint256 objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] -
//             1;

//         uint256 divNumHorizontal = objData[objDataIndex].divNumHorizontal;
//         uint256 divNumVertical = objData[objDataIndex].divNumVertical;
//         uint256[] memory baseVVector = objData[objDataIndex].baseVVector;
//         uint256[] memory baseVnVector = objData[objDataIndex].baseVnVector;

//         console.log(
//             "########################################################################"
//         );
//         console.log(Strings.toString(divNumHorizontal));
//         console.log(Strings.toString(divNumVertical));
//         console.log(Strings.toString(baseVVector[0]));
//         console.log(Strings.toString(baseVnVector[0]));
//         console.log(
//             "########################################################################"
//         );

//         string memory vVector = createVector("v", divNumVertical, baseVVector);
//         console.log(unicode"vVectorは通りました。");

//         string memory vnVector = createVector(
//             "vn",
//             divNumVertical,
//             baseVnVector
//         );
//         console.log(unicode"vnVectorは通りました。");

//         vVector = string.concat("v -0 1 0\n", vVector, "v 0 -1 0\n");

//         string memory fMesh = createF(
//             divNumHorizontal,
//             divNumHorizontal * divNumVertical
//         );

//         fMesh = string.concat(
//             unicode"# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n",
//             vVector,
//             vnVector,
//             "usemtl None\ns off\n",
//             fMesh
//         );

//         return fMesh;
//     }

//     function createObjData(
//         uint256 _divNumHorizontal,
//         uint256 _divNumVertical,
//         uint256[] memory _baseVVector,
//         uint256[] memory _baseVnVector
//     ) public {
//         ObjData memory _newObjData = ObjData(
//             _divNumHorizontal,
//             _divNumVertical,
//             _baseVVector,
//             _baseVnVector
//         );
//         objData.push(_newObjData);
//         divNumHorizontalToObjDataId[_divNumHorizontal] = objDataId;
//         objDataId++;
//     }
// }

// // 12, 6, [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0], [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]

// // v
// // [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0]

// // vn
// // [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]
