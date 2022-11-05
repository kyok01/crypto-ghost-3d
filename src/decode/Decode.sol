// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Trigonometry.sol";

contract Decode {
    using Trigonometry for uint;

    function getSinCos() internal {
        uint angle = 60; // degree
        int radias = 800; // pixel
        uint x = (angle * 0x4000 / 360).cos() * radias / 0x7fff;
        uint y = (angle * 0x4000 / 360).sin() * radias / 0x7fff;
    }
}
