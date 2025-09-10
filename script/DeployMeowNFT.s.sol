// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MeowNFT} from "../src/MeowNFT.sol";

contract DeployMeowNFT is Script {
    function run() public {
        // ********** IMPORTANT **********
        // PASTE THE METADATA FOLDER CID FROM PINATA HERE
        string memory metadataBaseURI = "ipfs://bafybeig4qh422yle7hiuq6beokguwuas2mid2yqh2cqnkputc4pbklhm3y/";
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        console.log("Deploying MeowNFT contract...");
        console.log("Deployer address:", vm.addr(deployerPrivateKey));
        
        MeowNFT meowNFT = new MeowNFT(metadataBaseURI);
        
        console.log("MeowNFT contract deployed to:", address(meowNFT));
        console.log("Base URI set to:", metadataBaseURI);
        
        vm.stopBroadcast();
    }
}