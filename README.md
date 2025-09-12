# CUHKSZ Meow NFT 🐱

[![Solidity](https://img.shields.io/badge/Solidity-0.8.28-blue.svg)](https://solidity.readthedocs.io)
[![Polygon](https://img.shields.io/badge/Polygon-Mainnet-purple.svg)](https://polygon.technology/)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-Contracts-orange.svg)](https://openzeppelin.com/contracts/)

**CUHKSZ校园猫咪NFT收藏品** - 一个专为香港中文大学（深圳）校园猫咪打造的ERC721 NFT项目。

## 📋 项目概览

- **合约名称**: CUHKSZ Meow NFT
- **代币符号**: MEOW
- **总供应量**: 68个独特的校园猫咪NFT
- **区块链**: Polygon主网
- **标准**: ERC721 (OpenZeppelin)

## 🌐 部署信息

### Polygon 主网
- **合约地址**: [`0x5cEe3Fd734cA83a160D42929092A89a6c048103b`](https://polygonscan.com/address/0x5cEe3Fd734cA83a160D42929092A89a6c048103b)
- **部署者**: `0x7f2074Bb22C8abb6ECe5FE2B42787d5135FD9136`
- **网络**: Polygon 主网 (Chain ID: 137)
- **IPFS元数据**: `ipfs://bafybeig4qh422yle7hiuq6beokguwuas2mid2yqh2cqnkputc4pbklhm3y/`

### 🔗 链接
- **PolygonScan**: https://polygonscan.com/address/0x5cEe3Fd734cA83a160D42929092A89a6c048103b
- **OpenSea**: https://opensea.io/collection/cuhksz-meow-nft

## ✨ 特性

- ✅ **ERC721标准**: 完全兼容的NFT合约
- ✅ **批量空投**: 高效的批量分发功能
- ✅ **重入保护**: 使用OpenZeppelin的ReentrancyGuard
- ✅ **唯一性保证**: 每个地址只能接收一次NFT
- ✅ **IPFS存储**: 去中心化的元数据存储
- ✅ **所有者管理**: 安全的权限控制

## 🏗️ 技术栈

- **智能合约**: Solidity 0.8.28
- **开发框架**: Foundry
- **合约库**: OpenZeppelin Contracts
- **区块链**: Polygon
- **存储**: IPFS
- **测试**: Forge

## 📦 安装与设置

### 前置要求
```bash
# 安装 Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# 克隆项目
git clone https://github.com/your-username/Meow-NFT.git
cd Meow-NFT
```

### 环境配置
```bash
# 复制环境变量模板
cp .env.example .env

# 编辑 .env 文件
PRIVATE_KEY=your_private_key_here
POLYGON_RPC_URL=https://polygon-rpc.com
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### 编译合约
```bash
forge build
```

### 运行测试
```bash
forge test
```

## 🚀 部署

### 1. 部署到Polygon主网
```bash
forge script script/DeployMeowNFT.s.sol:DeployMeowNFT \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --legacy
```

### 2. 空投NFT
```bash
# 编辑 script/AirdropMeowNFT.s.sol 中的接收地址
# 然后运行空投脚本
forge script script/AirdropMeowNFT.s.sol:AirdropMeowNFTTest \
  --rpc-url $POLYGON_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --legacy
```

## 🎨 NFT元数据

每个NFT都有独特的元数据，存储在IPFS上：

```json
{
  "name": "CUHKSZ Campus Cat #1",
  "description": "A unique NFT featuring the beloved cats of CUHKSZ campus",
  "image": "ipfs://bafybeig4qh422yle7hiuq6beokguwuas2mid2yqh2cqnkputc4pbklhm3y/1.png",
  "attributes": [
    {
      "trait_type": "Location",
      "value": "CUHKSZ Campus"
    },
    {
      "trait_type": "Rarity",
      "value": "Common"
    }
  ]
}
```

## 📝 合约接口

### 主要函数

```solidity
// 批量空投NFT
function airdropNFTs(address[] calldata recipients) external onlyOwner

// 获取总供应量
function totalSupply() external view returns (uint256)

// 设置基础URI
function setBaseURI(string calldata newBaseURI) external onlyOwner

// 检查是否已接收NFT
function hasReceived(address account) external view returns (bool)
```

## 🔒 安全特性

- **访问控制**: 使用OpenZeppelin的Ownable模式
- **重入保护**: ReentrancyGuard防止重入攻击
- **输入验证**: 严格的参数验证
- **唯一性检查**: 防止重复分发

## 📊 Gas费用估算

| 操作 | 预估Gas | 备注 |
|------|---------|------|
| 部署合约 | ~2,000,000 | 一次性费用 |
| 单个空投 | ~170,000 | 每个NFT |
| 批量空投(10个) | ~1,200,000 | 平均每个120k |

## 🤝 贡献

欢迎贡献！请遵循以下步骤：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目使用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [OpenZeppelin](https://openzeppelin.com/) - 安全的智能合约库
- [Foundry](https://github.com/foundry-rs/foundry) - 快速的以太坊开发工具链
- [Polygon](https://polygon.technology/) - 低费用的区块链网络
- [IPFS](https://ipfs.tech/) - 去中心化存储网络

## 📞 联系

如有问题或建议，请通过以下方式联系：

- GitHub Issues: [创建Issue](https://github.com/your-username/Meow-NFT/issues)
- 项目维护者: [@your-username](https://github.com/your-username)

---

**注意**: 本项目仅用于教育和展示目的。请在主网部署前充分测试。