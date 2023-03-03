<img align="right" width="150" height="150" top="100" src="./public/readme.png">

# Virtual Safe Token • [![tests](https://github.com/refcell/femplate/actions/workflows/ci.yml/badge.svg?label=tests)](https://github.com/refcell/femplate/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/refcell/femplate?label=license) ![solidity](https://img.shields.io/badge/solidity-^0.8.19-lightgrey)

# vSAFE

Converts non-transferable SAFE Tokens held in a Safe multisig wallet into a transferable version (vSAFE).

## Background

Currently Safe Tokens are non-transferable but claimable by eligible Safes.

While there have been two snapshot proposals ([1](https://snapshot.org/#/safegov.eth/proposal/0xe72815c4eef26024868ee77af637c96ad0b844df4957b969d8ca04fca67094f7), [2](https://snapshot.org/#/safe.eth/proposal/0x1b48a83c44e323275a605b244a05bde89918fb9ec86be7bb83792eb26e544441)) directed to Safe Token holders to turn on transferability (the "DAO"), the DAO did not end up recommending unpausing the tokens to the current owner of the Safe Token contract, the Safe Foundation.

Transferability still seems like a useful direction to explore, if only to provide additional data to the DAO regarding the market price of participating in the DAO, as well as explore early integrations of SAFE into other protocols.

This initial phase of transferability is supported by the technical implementation of vSAFE by using a secondary ERC20 token that can be minted by current SAFE holders that add vSAFE as a transaction guard.

The transaction guard prevents moving SAFE tokens without redeeming vSAFE tokens, therefore establishing their 1:1 representation and backing as a virtual unit of account. In this sense, each vSAFE user contributes to a shared pool of claimable SAFE when it unlocks, but at all times, can burn their vSAFE to get their SAFE back or turn off the transaction guard.

## User Story

Alice has some SAFE locked in her Safe wallet. Alice thinks SAFE is super cool but wants to join BOB DAO and needs ETH.

Alice converts the SAFE into vSAFE and sells tokens to Charlie. Alice now has more ETH and can join BOB DAO.

Later when (or if?) SAFE unlocks, Charlie can convert vSAFE to SAFE. Nice.

### Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._

See [LICENSE](./LICENSE) for more details.
