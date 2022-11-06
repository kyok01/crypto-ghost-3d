// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DecodeObjTest {
    using Strings for *;

    struct VectorData {
        uint divNumHorizontal;
        uint divNumVertical;
        string[] baseVVector; // vの配列
        string[] baseVnVector; // vnの配列
    }

    struct Goast {
        string name; // goast name
        string material; // goast material
        string description; // goast description
        uint goastId; // goast ID
        uint vectorDataIndex; // vectorData index
    }

    VectorData[] public vectorData;
    Goast[] public goast;

    uint goadtIdCounter = 1;
    uint objDataId = 1;

    mapping(uint=>uint) divNumHorizontalToObjDataId;

    function createVVector(uint index, string[] memory vectorBaseArray, string memory vector, string memory vectorZInversion) public pure returns(
        string memory,
        string memory
    ) {
        vector = string.concat(vector, "v -", vectorBaseArray[index*9+2], " ", vectorBaseArray[index*9+1], " ", vectorBaseArray[index*9], "\n");
        vectorZInversion = string.concat(vectorZInversion, "v -", vectorBaseArray[index*9+2], " -", vectorBaseArray[index*9+1], " ", vectorBaseArray[index*9], "\n");

        for (uint i=2; i > 0; i--) {
            vector = string.concat(vector, "v -", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "v -", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
        }

        for (uint i=0; i < 3; i++) {
            if (keccak256(abi.encodePacked(vectorBaseArray[index*9+i*3+2])) == keccak256(abi.encodePacked("0.0"))) {
                vector = string.concat(vector, "v -", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
                vectorZInversion = string.concat(vectorZInversion, "v -", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
            } else {
                vector = string.concat(vector, "v -", vectorBaseArray[i*3], " ", vectorBaseArray[i*3+1], " ", vectorBaseArray[i*3+2], "\n");
                vectorZInversion = string.concat(vectorZInversion, "v -", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");

            }
        }

        vector = string.concat(vector, "v ", vectorBaseArray[index*9+2], " ", vectorBaseArray[index*9+1], " -", vectorBaseArray[index*9], "\n");
        vectorZInversion = string.concat(vectorZInversion, "v ", vectorBaseArray[index*9+2], " -", vectorBaseArray[index*9+1], " -", vectorBaseArray[index*9], "\n");

        for (uint i=2; i > 0; i--) {
            vector = string.concat(vector, "v ", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "v ", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
        }

        return (vector, vectorZInversion);
    }

    function createVnVector(uint index, string[] memory vectorBaseArray, string memory vector, string memory vectorZInversion) public pure returns(
        string memory,
        string memory
    ) {
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn -", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "vn -", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " ", vectorBaseArray[index*9+i*3+2], "\n");
        }
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn -", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "vn -", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
        }
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn ", vectorBaseArray[index*9+i*3], " ", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "vn ", vectorBaseArray[index*9+i*3], " -", vectorBaseArray[index*9+i*3+1], " -", vectorBaseArray[index*9+i*3+2], "\n");
        }

        return (vector, vectorZInversion);
    }

    function createF(
        uint _divNumHorizontal,
        uint _divNum
    ) public pure returns(string memory) {
        string memory fMesh;
        for (uint index=1; index <= _divNum; index++) {
            string memory indexString = Strings.toString(index);
            if (index < _divNumHorizontal) {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index+1), "/", indexString, "/", indexString, " 1/", indexString, "/", indexString, " ", Strings.toString(index+2), "/", indexString, "/", indexString, "\n");
            } else if (index == _divNumHorizontal) {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index+1), "/", indexString, "/", indexString, " 1/", indexString, "/", indexString, " ", Strings.toString(index-10), "/", indexString, "/", indexString, "\n");
            } else if (index == _divNum) {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index-_divNumHorizontal*2+2), "/", indexString, "/", indexString, " 62/", indexString, "/", indexString, " ", Strings.toString(index-_divNumHorizontal+1), "/", indexString, "/", indexString, "\n");
            } else if (index >= _divNum-_divNumHorizontal+1) {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index-_divNumHorizontal+2), "/", indexString, "/", indexString, " 62/", indexString, "/", indexString, " ", Strings.toString(index-_divNumHorizontal+1), "/", indexString, "/", indexString, "\n");
            } else if (index % _divNumHorizontal == 0) {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index-_divNumHorizontal*2+2), "/", indexString, "/", indexString, " ", Strings.toString(index-_divNumHorizontal+2), "/", indexString, "/", indexString);
                fMesh = string.concat(fMesh, " ", Strings.toString(index+1), "/", indexString, "/", indexString, " ", Strings.toString(index-_divNumHorizontal+1), "/", indexString, "/", indexString, "\n");
            } else {
                fMesh = string.concat(fMesh, "f ", Strings.toString(index-_divNumHorizontal+2), "/", indexString, "/", indexString, " ", Strings.toString(index+2), "/", indexString, "/", indexString);
                fMesh = string.concat(fMesh, " ", Strings.toString(index+1), "/", indexString, "/", indexString, " ", Strings.toString(index-_divNumHorizontal+1), "/", indexString, "/", indexString, "\n");
            }
        }

        return fMesh;
    }

    function createVector(
            string memory _vectorKind,
            uint divNumVertical,
            string[] memory baseVVector
        ) public pure returns(string memory) {
        string memory vector;
        string memory endZInversionVector;
        string memory vectorZInversion;
        for (uint i=0; i < divNumVertical/2; i++) {
            vector = string.concat(vector, _vectorKind, " ", baseVVector[i*9], " ", baseVVector[i*9+1], " ", baseVVector[i*9+2], "\n");   // objテキストとして最後に返す文字列
            vector = string.concat(vector, _vectorKind, " ", baseVVector[i*9+3], " ", baseVVector[i*9+4], " ", baseVVector[i*9+5], "\n");   // objテキストとして最後に返す文字列
            vector = string.concat(vector, _vectorKind, " ", baseVVector[i*9+6], " ", baseVVector[i*9+7], " ", baseVVector[i*9+8], "\n");   // objテキストとして最後に返す文字列
            endZInversionVector = string.concat(_vectorKind, " ", baseVVector[i*9], " -", baseVVector[i*9+1], " ", baseVVector[i*9+2], "\n");
            endZInversionVector = string.concat(endZInversionVector, _vectorKind, " ", baseVVector[i*9+3], " -", baseVVector[i*9+4], " ", baseVVector[i*9+5], "\n");
            endZInversionVector = string.concat(endZInversionVector, _vectorKind, " ", baseVVector[i*9+6], " -", baseVVector[i*9+7], " ", baseVVector[i*9+8], "\n");


            if (keccak256(abi.encodePacked(_vectorKind)) == keccak256(abi.encodePacked("v"))) {
                (vector, endZInversionVector) = createVVector(i, baseVVector, vector, endZInversionVector);
                if (divNumVertical/2-1 != i) {
                    vectorZInversion = string.concat(endZInversionVector, vectorZInversion);
                }
            } else {
                (vector, endZInversionVector) = createVnVector(i, baseVVector, vector, endZInversionVector);
                vectorZInversion = string.concat(endZInversionVector, vectorZInversion);
            }
        }


        vector = string.concat(vector, vectorZInversion);

        return vector;
    }

    function createObjFile(
        uint _divNumHorizontal
    ) internal view returns(string memory) {
        require(divNumHorizontalToObjDataId[_divNumHorizontal] > 0, "The specified number of divisions is not registered.");
        uint objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] - 1;

        uint divNumHorizontal = vectorData[objDataIndex].divNumHorizontal;
        uint divNumVertical = vectorData[objDataIndex].divNumVertical;
        string[] memory baseVVector = vectorData[objDataIndex].baseVVector;
        string[] memory baseVnVector = vectorData[objDataIndex].baseVnVector;

        string memory vVector = createVector("v", divNumVertical, baseVVector);

        string memory vnVector = createVector("vn", divNumVertical, baseVnVector);

        vVector = string.concat("v -0 1 0\n", vVector, "v 0 -1 0\n");

        string memory fMesh = createF(divNumHorizontal, divNumHorizontal*divNumVertical);

        fMesh = string.concat(unicode"# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n", vVector, vnVector, "usemtl None\ns off\n", fMesh);
        console.log("fMesh create");
        fMesh = Base64.encode(bytes(fMesh));
        // Base64
        fMesh = string(abi.encodePacked("data:model/obj,", string(fMesh)));
        return fMesh;
    }


    function addVectorData(
        uint _divNumHorizontal,
        uint _divNumVertical,
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

    function writeGoast(
        string memory _name,
        string memory _description,
        string memory _material,
        uint _divNumHorizontal
        ) external {
        uint vectorDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal];
        Goast memory _newGoast = Goast(
            _name,
            _description,
            _material,
            goadtIdCounter,
            vectorDataIndex
        );
        goast.push(_newGoast);
        goadtIdCounter++;
    }

    function readGoast(uint goastId, uint _divNumHorizontal) external view
    returns (
        string memory,
        string memory,
        string memory,
        string memory,
        uint,
        uint
    ){
        string memory objString = createObjFile(_divNumHorizontal);
        return (
            objString,
            goast[goastId-1].name,
            goast[goastId-1].description,
            goast[goastId-1].material,
            goast[goastId-1].goastId,
            goast[goastId-1].vectorDataIndex
        );

    }

    function getAllGoast() external view returns(Goast[] memory) {
        return goast;
    }
}



