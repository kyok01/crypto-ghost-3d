// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import { Base64 } from "./libraries/Base64.sol";
import "./MintNft.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DecodeObjTest is MintNft {
    using Strings for *;

    struct VectorData {
        uint256 divNumHorizontal;
        uint256 divNumVertical;
        string[] baseVVector; // vの配列
        string[] baseVnVector; // vnの配列
    }

    struct Ghost {
        string name; // ghost name
        string description; // ghost description
        string material; // ghost material
        uint256 ghostId; // ghost ID
        uint256 vectorDataIndex; // vectorData index
    }

    VectorData[] public vectorData;
    Ghost[] public ghost;

    uint256 goadtIdCounter = 1;
    uint256 objDataId = 1;

    mapping(uint256 => uint256) divNumHorizontalToObjDataId;

    function createVVector(
        uint256 index,
        string[] memory vectorBaseArray,
        string memory vector,
        string memory vectorZInversion
    ) public pure returns (string memory, string memory) {
        vector = string.concat(
            vector,
            "v -",
            vectorBaseArray[index * 9 + 2],
            " ",
            vectorBaseArray[index * 9 + 1],
            " ",
            vectorBaseArray[index * 9],
            "\n"
        );
        vectorZInversion = string.concat(
            vectorZInversion,
            "v -",
            vectorBaseArray[index * 9 + 2],
            " -",
            vectorBaseArray[index * 9 + 1],
            " ",
            vectorBaseArray[index * 9],
            "\n"
        );

        for (uint256 i = 2; i > 0; i--) {
            vector = string.concat(
                vector,
                "v -",
                vectorBaseArray[index * 9 + i * 3],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
            vectorZInversion = string.concat(
                vectorZInversion,
                "v -",
                vectorBaseArray[index * 9 + i * 3],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
        }

        for (uint256 i = 0; i < 3; i++) {
            if (
                keccak256(
                    abi.encodePacked(vectorBaseArray[index * 9 + i * 3 + 2])
                ) == keccak256(abi.encodePacked("0.0"))
            ) {
                vector = string.concat(
                    vector,
                    "v -",
                    vectorBaseArray[index * 9 + i * 3],
                    " ",
                    vectorBaseArray[index * 9 + i * 3 + 1],
                    " ",
                    vectorBaseArray[index * 9 + i * 3 + 2],
                    "\n"
                );
                vectorZInversion = string.concat(
                    vectorZInversion,
                    "v -",
                    vectorBaseArray[index * 9 + i * 3],
                    " -",
                    vectorBaseArray[index * 9 + i * 3 + 1],
                    " ",
                    vectorBaseArray[index * 9 + i * 3 + 2],
                    "\n"
                );
            } else {
                vector = string.concat(
                    vector,
                    "v -",
                    vectorBaseArray[index * 9 + i * 3],
                    " ",
                    vectorBaseArray[index * 9 + i * 3 + 1],
                    " -",
                    vectorBaseArray[index * 9 + i * 3 + 2],
                    "\n"
                );
                vectorZInversion = string.concat(
                    vectorZInversion,
                    "v -",
                    vectorBaseArray[index * 9 + i * 3],
                    " -",
                    vectorBaseArray[index * 9 + i * 3 + 1],
                    " -",
                    vectorBaseArray[index * 9 + i * 3 + 2],
                    "\n"
                );
            }
        }

        vector = string.concat(
            vector,
            "v ",
            vectorBaseArray[index * 9 + 2],
            " ",
            vectorBaseArray[index * 9 + 1],
            " -",
            vectorBaseArray[index * 9],
            "\n"
        );
        vectorZInversion = string.concat(
            vectorZInversion,
            "v ",
            vectorBaseArray[index * 9 + 2],
            " -",
            vectorBaseArray[index * 9 + 1],
            " -",
            vectorBaseArray[index * 9],
            "\n"
        );

        for (uint256 i = 2; i > 0; i--) {
            vector = string.concat(
                vector,
                "v ",
                vectorBaseArray[index * 9 + i * 3],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
            vectorZInversion = string.concat(
                vectorZInversion,
                "v ",
                vectorBaseArray[index * 9 + i * 3],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
        }

        return (vector, vectorZInversion);
    }

    function createVnVector(
        uint256 index,
        string[] memory vectorBaseArray,
        string memory vector,
        string memory vectorZInversion
    ) public pure returns (string memory, string memory) {
        for (uint256 i = 0; i < 3; i++) {
            vector = string.concat(
                vector,
                "vn -",
                vectorBaseArray[index * 9 + i * 3],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
            vectorZInversion = string.concat(
                vectorZInversion,
                "vn -",
                vectorBaseArray[index * 9 + i * 3],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
        }
        for (uint256 i = 0; i < 3; i++) {
            vector = string.concat(
                vector,
                "vn -",
                vectorBaseArray[index * 9 + i * 3],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
            vectorZInversion = string.concat(
                vectorZInversion,
                "vn -",
                vectorBaseArray[index * 9 + i * 3],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
        }
        for (uint256 i = 0; i < 3; i++) {
            vector = string.concat(
                vector,
                "vn ",
                vectorBaseArray[index * 9 + i * 3],
                " ",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
            vectorZInversion = string.concat(
                vectorZInversion,
                "vn ",
                vectorBaseArray[index * 9 + i * 3],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 1],
                " -",
                vectorBaseArray[index * 9 + i * 3 + 2],
                "\n"
            );
        }

        return (vector, vectorZInversion);
    }

    function createF(uint256 _divNumHorizontal, uint256 _divNum)
        public
        pure
        returns (string memory)
    {
        string memory fMesh;
        for (uint256 index = 1; index <= _divNum; index++) {
            string memory indexString = Strings.toString(index);
            if (index < _divNumHorizontal) {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " 1/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index + 2),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            } else if (index == _divNumHorizontal) {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " 1/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - 10),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            } else if (index == _divNum) {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index - _divNumHorizontal * 2 + 2),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " 62/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - _divNumHorizontal + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            } else if (index >= _divNum - _divNumHorizontal + 1) {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index - _divNumHorizontal + 2),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " 62/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - _divNumHorizontal + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            } else if (index % _divNumHorizontal == 0) {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index - _divNumHorizontal * 2 + 2),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - _divNumHorizontal + 2),
                    "/",
                    indexString,
                    "/",
                    indexString
                );
                fMesh = string.concat(
                    fMesh,
                    " ",
                    Strings.toString(index + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - _divNumHorizontal + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            } else {
                fMesh = string.concat(
                    fMesh,
                    "f ",
                    Strings.toString(index - _divNumHorizontal + 2),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index + 2),
                    "/",
                    indexString,
                    "/",
                    indexString
                );
                fMesh = string.concat(
                    fMesh,
                    " ",
                    Strings.toString(index + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    " ",
                    Strings.toString(index - _divNumHorizontal + 1),
                    "/",
                    indexString,
                    "/",
                    indexString,
                    "\n"
                );
            }
        }

        return fMesh;
    }

    function createVector(
        string memory _vectorKind,
        uint256 divNumVertical,
        string[] memory baseVVector
    ) public pure returns (string memory) {
        string memory vector;
        string memory endZInversionVector;
        string memory vectorZInversion;
        for (uint256 i = 0; i < divNumVertical / 2; i++) {
            vector = string.concat(
                vector,
                _vectorKind,
                " ",
                baseVVector[i * 9],
                " ",
                baseVVector[i * 9 + 1],
                " ",
                baseVVector[i * 9 + 2],
                "\n"
            ); // objテキストとして最後に返す文字列
            vector = string.concat(
                vector,
                _vectorKind,
                " ",
                baseVVector[i * 9 + 3],
                " ",
                baseVVector[i * 9 + 4],
                " ",
                baseVVector[i * 9 + 5],
                "\n"
            ); // objテキストとして最後に返す文字列
            vector = string.concat(
                vector,
                _vectorKind,
                " ",
                baseVVector[i * 9 + 6],
                " ",
                baseVVector[i * 9 + 7],
                " ",
                baseVVector[i * 9 + 8],
                "\n"
            ); // objテキストとして最後に返す文字列
            endZInversionVector = string.concat(
                _vectorKind,
                " ",
                baseVVector[i * 9],
                " -",
                baseVVector[i * 9 + 1],
                " ",
                baseVVector[i * 9 + 2],
                "\n"
            );
            endZInversionVector = string.concat(
                endZInversionVector,
                _vectorKind,
                " ",
                baseVVector[i * 9 + 3],
                " -",
                baseVVector[i * 9 + 4],
                " ",
                baseVVector[i * 9 + 5],
                "\n"
            );
            endZInversionVector = string.concat(
                endZInversionVector,
                _vectorKind,
                " ",
                baseVVector[i * 9 + 6],
                " -",
                baseVVector[i * 9 + 7],
                " ",
                baseVVector[i * 9 + 8],
                "\n"
            );

            if (
                keccak256(abi.encodePacked(_vectorKind)) ==
                keccak256(abi.encodePacked("v"))
            ) {
                (vector, endZInversionVector) = createVVector(
                    i,
                    baseVVector,
                    vector,
                    endZInversionVector
                );
                if (divNumVertical / 2 - 1 != i) {
                    vectorZInversion = string.concat(
                        endZInversionVector,
                        vectorZInversion
                    );
                }
            } else {
                (vector, endZInversionVector) = createVnVector(
                    i,
                    baseVVector,
                    vector,
                    endZInversionVector
                );
                vectorZInversion = string.concat(
                    endZInversionVector,
                    vectorZInversion
                );
            }
        }

        vector = string.concat(vector, vectorZInversion);

        return vector;
    }

    function createObjFile(uint256 _divNumHorizontal)
        public
        view
        returns (string memory)
    {
        require(
            divNumHorizontalToObjDataId[_divNumHorizontal] > 0,
            "The specified number of divisions is not registered."
        );
        uint256 objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] -
            1;

        uint256 divNumHorizontal = vectorData[objDataIndex].divNumHorizontal;
        uint256 divNumVertical = vectorData[objDataIndex].divNumVertical;
        string[] memory baseVVector = vectorData[objDataIndex].baseVVector;
        string[] memory baseVnVector = vectorData[objDataIndex].baseVnVector;

        string memory vVector = createVector("v", divNumVertical, baseVVector);

        string memory vnVector = createVector(
            "vn",
            divNumVertical,
            baseVnVector
        );

        vVector = string.concat("v -0 1 0\n", vVector, "v 0 -1 0\n");

        string memory fMesh = createF(
            divNumHorizontal,
            divNumHorizontal * divNumVertical
        );

        fMesh = string.concat(
            unicode"# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n",
            vVector,
            vnVector,
            "usemtl None\ns off\n",
            fMesh
        );
        console.log("fMesh create");
        fMesh = Base64.encode(bytes(fMesh));
        // Base64
        fMesh = string(abi.encodePacked("data:model/obj,", string(fMesh)));
        return fMesh;
    }

    function addVectorData(
        uint256 _divNumHorizontal,
        uint256 _divNumVertical,
        string[] memory _baseVVector,
        string[] memory _baseVnVector
    ) public {
        VectorData memory _newObjData = VectorData(
            _divNumHorizontal,
            _divNumVertical,
            _baseVVector,
            _baseVnVector
        );
        vectorData.push(_newObjData);
        divNumHorizontalToObjDataId[_divNumHorizontal] = objDataId;
        objDataId++;
    }

    function writeGhost(
        string memory _name,
        string memory _description,
        string memory _material,
        uint _divNumHorizontal
    ) external {
        uint vectorDataIndex = divNumHorizontalToObjDataId[
            _divNumHorizontal
        ];
        Ghost memory _newGhost = Ghost(
            _name,
            _description,
            _material,
            goadtIdCounter,
            vectorDataIndex
        );
        ghost.push(_newGhost);
        goadtIdCounter++;

        ghostNftMint(_name, _description,
            vectorData[vectorDataIndex-1].divNumHorizontal,
            vectorData[vectorDataIndex-1].divNumVertical,
            vectorData[vectorDataIndex-1].baseVVector,
            vectorData[vectorDataIndex-1].baseVnVector
        );
    }

    function readGhost(uint256 ghostId, uint256 _divNumHorizontal)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            uint256,
            uint256
        )
    {
        string memory objString = createObjFile(_divNumHorizontal);
        return (
            objString,
            ghost[ghostId - 1].name,
            ghost[ghostId - 1].description,
            ghost[ghostId - 1].material,
            ghost[ghostId - 1].ghostId,
            ghost[ghostId - 1].vectorDataIndex
        );
    }

    function getAllGhost() external view returns (Ghost[] memory) {
        return ghost;
    }

}
