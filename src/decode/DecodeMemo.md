## createObjFile

```js
function createObjFile(
    uint _divNumHorizontal
) public view returns(string memory) {
    require(divNumHorizontalToObjDataId[_divNumHorizontal] > 0, "The specified number of divisions is not registered.");
    uint objDataIndex = divNumHorizontalToObjDataId[_divNumHorizontal] - 1;

    objData[objDataIndex]

    // string memory stringVectorX = Strings.toString(uint(vectorX));
    // string memory stringVectorY = Strings.toString(uint(vectorY));
    // string memory stringVectorZ = Strings.toString(uint(vectorZ));

    // string[] memory baseVectorArray = new string[](9);
    // baseVectorArray[0] = stringVectorX;
    // baseVectorArray[1] = stringVectorZ;
    // baseVectorArray[2] = stringVectorY;

    // string memory vector = string.concat(_vectorKind, _vectorKind, " ", stringVectorX, " ", stringVectorZ, " ", stringVectorY, "\n");   // objテキストとして最後に返す文字列
    // string memory vectorZInversion = string.concat(_vectorKind, " ", stringVectorX, " -", stringVectorZ, " ", stringVectorY, "\n");

    // for (uint _i=0; _i < _horizontalPixel/4-1; _i++) {
    //     int nextVectorX;
    //     int nextVectorY;
    //     (nextVectorX, nextVectorY) = createBaseObjVector(vectorX, vectorY);
    //     baseVectorArray[_i+3] = Strings.toString(uint(nextVectorX));
    //     baseVectorArray[_i+4] = stringVectorZ;
    //     baseVectorArray[_i+5] = Strings.toString(uint(nextVectorY));

    //     vectorX = nextVectorX;
    //     vectorY = nextVectorY;

    //     stringVectorX = Strings.toString(uint(nextVectorX));
    //     stringVectorY = Strings.toString(uint(nextVectorY));

    //     vector = string.concat(vector, _vectorKind, " ", stringVectorX, " ", stringVectorZ, " ", stringVectorY, "\n");
    //     vectorZInversion = string.concat(vectorZInversion, _vectorKind, " ", stringVectorX, " -", stringVectorZ, " ", stringVectorY, "\n");
    // }

    // if (_vectorKind == "v") {
    //     createVVector();
    // } else {
    //     createVnVector();
    // }

    return "A";
}
```
