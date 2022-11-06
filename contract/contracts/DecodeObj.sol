// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Trigonometry.sol";
import "./Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DecodeObj {
    using Trigonometry for uint;
    using Strings for *;

    struct ObjData {
        uint divNumHorizontal;
        uint divNumVertical;
        uint[] baseVVector; // vの配列
        uint[] baseVnVector; // vnの配列
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

    function createVVector(string[] memory vectorBaseArray, string memory vector) public pure returns(
        string memory,
        string memory
    ) {
        // x軸マイナス
        // 左上の箇所のため、x軸の値が0になる。
        vector = string.concat(vector, "v -0.", vectorBaseArray[2], " 0.", vectorBaseArray[1], " 0.", vectorBaseArray[0], "\n");
        string memory vectorZInversion = string.concat("v -0.", vectorBaseArray[2], " -0.", vectorBaseArray[1], " 0.", vectorBaseArray[0], "\n");

        for (uint i=2; i > 0; i--) {
            vector = string.concat(vector, "v -0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "v -0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
        }

        for (uint i=0; i < 3; i++) {
            if (keccak256(abi.encodePacked(vectorBaseArray[i*3+2])) == keccak256(abi.encodePacked("0.0"))) {
                vector = string.concat(vector, "v -0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
                vectorZInversion = string.concat(vectorZInversion, "v -0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
            } else {
                vector = string.concat(vector, "v -0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
                vectorZInversion = string.concat(vectorZInversion, "v -0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");

            }
        }

        vector = string.concat(vector, "v 0.", vectorBaseArray[2], " 0.", vectorBaseArray[1], " -0.", vectorBaseArray[0], "\n");
        vectorZInversion = string.concat(vectorZInversion, "v 0.", vectorBaseArray[2], " -0.", vectorBaseArray[1], " -0.", vectorBaseArray[0], "\n");

        for (uint i=2; i > 0; i--) {
            vector = string.concat(vector, "v 0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "v 0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
        }

        return (vector, vectorZInversion);
    }

    function createVnVector(string[] memory vectorBaseArray, string memory vector) public pure returns(
        string memory,
        string memory
    ) {
        string memory vectorZInversion;
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn -0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
            vectorZInversion = string.concat( "vn -0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " 0.", vectorBaseArray[i*3+2], "\n");
        }
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn -0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "vn -0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
        }
        for (uint i=0; i < 3; i++) {
            vector = string.concat(vector, "vn 0.", vectorBaseArray[i*3], " 0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
            vectorZInversion = string.concat(vectorZInversion, "vn 0.", vectorBaseArray[i*3], " -0.", vectorBaseArray[i*3+1], " -0.", vectorBaseArray[i*3+2], "\n");
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
            uint divNumHorizontal,
            uint[] memory baseVVector
        ) public view returns(string memory) {
        string memory vector;
        string memory allZInversionVector;
        for (uint i=0; i < divNumHorizontal/2; i++) {
            console.log(unicode"for文開始");
            string memory stringVectorX = Strings.toString(uint(baseVVector[i]));
            string memory stringVectorY = Strings.toString(uint(baseVVector[i+1]));
            string memory stringVectorZ = Strings.toString(uint(baseVVector[i+2]));

            string[] memory baseVectorArray = new string[](9);
            baseVectorArray[0] = stringVectorX;
            baseVectorArray[1] = stringVectorZ;
            baseVectorArray[2] = stringVectorY;

            vector = string.concat(_vectorKind, " 0.", stringVectorX, " 0.", stringVectorZ, " 0.", stringVectorY, "\n");   // objテキストとして最後に返す文字列
            string memory vectorZInversion = string.concat(_vectorKind, " 0.", stringVectorX, " -0.", stringVectorZ, " 0.", stringVectorY, "\n");

            int nextVectorX = int(baseVVector[0]);
            int nextVectorY = int(baseVVector[1]);
            for (uint _i=0; _i < divNumHorizontal/2-1; _i++) {
                console.log(unicode"for文の中のfor文開始");
                (nextVectorX, nextVectorY) = createBaseObjVector(nextVectorX, nextVectorY);
                baseVectorArray[_i*3+3] = Strings.toString(uint(nextVectorX));
                baseVectorArray[_i*3+4] = stringVectorZ;
                baseVectorArray[_i*3+5] = Strings.toString(uint(nextVectorY));

                stringVectorX = Strings.toString(uint(nextVectorX));
                stringVectorY = Strings.toString(uint(nextVectorY));

                vector = string.concat(vector, _vectorKind, " 0.", stringVectorX, " 0.", stringVectorZ, " 0.", stringVectorY, "\n");
                vectorZInversion = string.concat(vectorZInversion, _vectorKind, " 0.", stringVectorX, " -0.", stringVectorZ, " 0.", stringVectorY, "\n");
                console.log(vector);
                console.log(vectorZInversion);
                console.log(unicode"for文の中のfor文終了");
            }
            allZInversionVector = vectorZInversion;

            if (keccak256(abi.encodePacked(_vectorKind)) == keccak256(abi.encodePacked("v"))) {
                console.log(unicode"createVVector開始");
                (vector, vectorZInversion) = createVVector(baseVectorArray, vector);
                allZInversionVector = string.concat(vectorZInversion, allZInversionVector);
            } else {
                (vector, vectorZInversion) = createVnVector(baseVectorArray, vector);
                allZInversionVector = string.concat(vectorZInversion, allZInversionVector);
            }
        }

        vector = string.concat(vector, allZInversionVector);

        return vector;
    }

    function createObjFile(
        uint _divNumHorizontal
    ) public view returns(string memory) {
        require(divNumHorizontalToObjDataId[_divNumHorizontal] > 0, "The specified number of divisions is not registered.");
        uint objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] - 1;

        uint divNumHorizontal = objData[objDataIndex].divNumHorizontal;
        uint divNumVertical = objData[objDataIndex].divNumVertical;
        uint[] memory baseVVector = objData[objDataIndex].baseVVector;
        uint[] memory baseVnVector = objData[objDataIndex].baseVnVector;

        console.log("########################################################################");
        console.log(Strings.toString(divNumHorizontal));
        console.log(Strings.toString(divNumVertical));
        console.log(Strings.toString(baseVVector[0]));
        console.log(Strings.toString(baseVnVector[0]));
        console.log("########################################################################");

        string memory vVector = createVector("v", divNumVertical, baseVVector);
        console.log(unicode"vVectorは通りました。");

        string memory vnVector = createVector("vn", divNumVertical, baseVnVector);
        console.log(unicode"vnVectorは通りました。");

        vVector = string.concat("v -0 1 0\n", vVector, "v 0 -1 0\n");

        string memory fMesh = createF(divNumHorizontal, divNumHorizontal*divNumVertical);

        fMesh = string.concat(unicode"# Blender v3.2.2 OBJ File: ''\n# www.blender.org\nmtllib sphere_12_6.mtl\no 球_球.001\n", vVector, vnVector, "usemtl None\ns off\n", fMesh);

        return fMesh;
    }


    function createObjData(
        uint _divNumHorizontal,
        uint _divNumVertical,
        uint[] memory _baseVVector,
        uint[] memory _baseVnVector
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


