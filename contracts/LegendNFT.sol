// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";


contract LegendNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public totalSupply;
 
    string baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: #FEFEFE; font-family: League Spartan; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string baseSvg2 = "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Elegant", "Exquisite", "Glorious", "Junoesque", "Magnificent", "Resplendent", "Splendid", "Statuesque", "Sublime", "Superb"];
    string[] secondWords = ["Python", "Javascript", "Java", "C#", "C", "C++", "Go", "Rust", "R", "Swift", "PHP"];
    string[] thirdWords = ["Code", "Gem", "Arts", "Work", "Masterstroke", "Program", "UI", "Masterpiece", "Showpiece", "Standard"];
    string[] colors = ["#BD1E51", "#00ABE1", "#161F6D", "#7DA2A9", "#00458B", "#1D2228", "#051622", "#438945", "#5C6E58", "#181818", "#2CCCC3","#FACD3D","#5626C4","#E60576"];


    event NewLegendNFTMinted(address sender, uint256 tokenId);


    constructor() ERC721 ("DEV Legend NFT", "DEV") {
        totalSupply = 10;
        console.log("This is my NFT contract. Whoa!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
  }


    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeLegendNFT() public {
        uint256 newItemId = _tokenIds.current();
        require(newItemId < totalSupply, "Total supply has been reached!");

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory randomColor = pickRandomColor(newItemId);

        string memory combinedWord = string(abi.encodePacked(first, " ",  second, " ", third));

        string memory svgString = string(abi.encodePacked(baseSvg1, randomColor, baseSvg2, combinedWord, "</text></svg>"));
                
        string memory TOKEN_JSON_URI = getTokenURI(combinedWord, svgString);

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, TOKEN_JSON_URI);
        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        emit NewLegendNFTMinted(msg.sender, newItemId);
    }

    function getTokenURI(string memory words, string memory svgString) internal pure returns (string memory) {

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        words,
                        '", "description": "A highly acclaimed collection for all developers.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(svgString)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return finalTokenUri;
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return _tokenIds.current() -1;
    }
}