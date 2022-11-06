// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Trigonometry.sol";
import "./Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DecodeObjTest {
    using Trigonometry for uint;
    using Strings for *;

    struct ObjData {
        uint divNumHorizontal;
        uint divNumVertical;
        string[] baseVVector; // vの配列
        string[] baseVnVector; // vnの配列
    }

    struct GoastData {
        string name;
        uint id;
        uint divNumHorizontal;
        uint objDataIndex;
    }

    ObjData[] public objData;

    mapping(uint=>uint) goastIdToGoastData;
    mapping(uint=>uint) divNumHorizontalToObjDataId;

    uint objDataId = 1;

    function getSinCos() public pure returns(int, int) {
        uint angle = 30; // degree

        int sin_num = (angle * 0x4000 / 360).sin() * 100000 / 0x7fff;
        int cos_num = (angle * 0x4000 / 360).cos() * 100000 / 0x7fff;


        return (sin_num, cos_num);
    }

    function createBaseObjVector(int xVector, int yVector) public pure returns(
        int,
        int
    ) {
        int sinNum;
        int cosNum;
        (sinNum, cosNum) = getSinCos();
        int nextX = cosNum * xVector + sinNum * yVector * -1;
        int nextY = sinNum * xVector + cosNum * yVector;

        return (nextX, nextY);
    }

    function createVVector(uint index, string[] memory vectorBaseArray, string memory vector, string memory vectorZInversion) public view returns(
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
        ) public view returns(string memory) {
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
    ) public view returns(string memory) {
        require(divNumHorizontalToObjDataId[_divNumHorizontal] > 0, "The specified number of divisions is not registered.");
        uint objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] - 1;

        uint divNumHorizontal = objData[objDataIndex].divNumHorizontal;
        uint divNumVertical = objData[objDataIndex].divNumVertical;
        string[] memory baseVVector = objData[objDataIndex].baseVVector;
        string[] memory baseVnVector = objData[objDataIndex].baseVnVector;

        string memory vVector = createVector("v", divNumVertical, baseVVector);

        string memory vnVector = createVector("vn", divNumVertical, baseVnVector);

        vVector = string.concat("v -0 1 0\n", vVector, "v 0 -1 0\n");

        string memory fMesh = createF(divNumHorizontal, divNumHorizontal*divNumVertical);

        fMesh = string.concat(unicode"# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n", vVector, vnVector, "usemtl None\ns off\n", fMesh);
        // Base64
        fMesh = Base64.encode(bytes(fMesh));
        return fMesh;
    }


    function createObjData(
        uint _divNumHorizontal,
        uint _divNumVertical,
        string[] memory _baseVVector,
        string[] memory _baseVnVector
    ) public {
        ObjData memory _newObjData = ObjData(
            _divNumHorizontal,
            _divNumVertical,
            _baseVVector,
            _baseVnVector
        );
        objData.push(_newObjData);
        divNumHorizontalToObjDataId[_divNumHorizontal] = objDataId;
        objDataId++;
    }
}

// 12, 6, [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0], [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]

// v
// [500000, 866025, 0, 866026, 500000, 0, 1, 0, 0]

// vn
// [2582, 9636, 692, 6947, 6947, 1862, 9351, 2506, 2506]


