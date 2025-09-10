// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title CUHKSZ Meow NFT
 * @dev ERC721 contract for the campus cat collection.
 * Includes a batch airdrop function for efficient distribution.
 */
contract MeowNFT is ERC721, Ownable, ReentrancyGuard {
    using Strings for uint256;

    // The base URI pointing to the metadata folder on IPFS
    string private _baseTokenURI;
    
    // Total number of NFTs in this collection
    uint256 public constant MAX_SUPPLY = 68;
    
    // Current token ID counter
    uint256 public currentTokenId;
    
    // Mapping to track if an address has received an airdrop
    mapping(address => bool) public hasReceived;

    event BatchAirdrop(address[] recipients, uint256[] tokenIds);
    event BaseURIUpdated(string newBaseURI);

    /**
     * @dev Constructor sets the token name, symbol, and initial metadata URI
     */
    constructor(
        string memory _initialBaseURI
    ) ERC721("CUHKSZ Meow NFT", "MEOW") {
        _baseTokenURI = _initialBaseURI;
    }

    /**
     * @dev Returns the base URI for all token metadata
     */
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Returns the token URI for a given token ID
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
            : "";
    }

    /**
     * @dev Updates the base URI (only owner)
     */
    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }

    /**
     * @dev Batch airdrop NFTs to multiple addresses
     * @param recipients Array of addresses to receive NFTs
     */
    function airdropNFTs(address[] calldata recipients) external onlyOwner nonReentrant {
        require(recipients.length > 0, "No recipients provided");
        require(currentTokenId + recipients.length <= MAX_SUPPLY, "Airdrop exceeds max supply");
        
        uint256[] memory tokenIds = new uint256[](recipients.length);
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            require(!hasReceived[recipients[i]], "Address already received NFT");
            
            currentTokenId++;
            tokenIds[i] = currentTokenId;
            hasReceived[recipients[i]] = true;
            
            _safeMint(recipients[i], currentTokenId);
        }
        
        emit BatchAirdrop(recipients, tokenIds);
    }

    /**
     * @dev Get total number of minted tokens
     */
    function totalSupply() external view returns (uint256) {
        return currentTokenId;
    }

    /**
     * @dev Check if max supply has been reached
     */
    function isMaxSupplyReached() external view returns (bool) {
        return currentTokenId >= MAX_SUPPLY;
    }
}