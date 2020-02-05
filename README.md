# Overview of Money Protocol

Published: 22nd Dec 2019
First Revision: 29 Jan 2020
Second Revision: 05 Feb 2020

Money protocol is a regulatory compliant standard for e-wallet, e-money, Digital Payment Token wallets to interact with the ecosystem of fiat on and off ramps that ShuttleOne operates within regulation permissive jurisdictions.

Money Protocol ringfences and works in a combination of:

1. Smart Contracts
2. APIs (for developers to connect to the protocol)
3. BIP39 Standard Seed Generation
4. The ShuttleOne Token (SZO)

ShuttleOne's Money Protocol requires KYC onchain through the ShuttleOne app. Only KYCed verified and approved users are able to transact.

The KYC data will be encrypted from client and stored on the blockchain, however only ShuttleOne is able to decrypt the KYC data to reveal the KYC details under law enforcement request or regulatory compliance.


# Overview of the ShuttleOne Token (SZO)

SZO is a utility token that can only be used on Shuttle One’s platform, to subsidize users’ transactions. 

When a transaction is conducted or a contract is executed on the Ethereum blockchain platform, a certain fee, known as ‘gas’, is required. Gas is priced in sub-units of the digital token Ether, known as gwei. Miners set the price of gas and can decline to process a transaction if it does not meet their price threshold. Gas is used to allocate resources of the Ethereum virtual machine so that decentralized applications such as smart contracts can self-execute in a secured fashion. 

Each SZO will be priced as 2-7 gwei for the purpose of paying for gas fees, which will reduce the cost of network fees to run the Shuttle One platform.  

A user will get SZO when they open a Shuttle One wallet, pass any required customer onboarding processes and procedures, and complete their first top up of the Shuttle One wallet. The number of SZO that will be issued will be priced according to the price of the Ethereum gas network at the point in time. Although SZO can also be bought from another platform, only users that open a Shuttle One wallet and pass any required customer onboarding processes and procedures will be able to use their SZO tokens in practice. 

At the initial stage, there will be 230 million total pre-minted tokens in Shuttle One’s smart contract, which is modelled on the initial expected number of users and partners within the Shuttle One ecosystem. In future, after all 230mil SZO are fully circulated, the contract has a hard coded minting condition of 5% new tokens to be minted to manage of the adoption of the Shuttle One mobile application, depending on the number of new users added. 

Holders of SZO may be entitled to promotional discount redemptions for a basket of daily necessities (eg. rice, cooking oil et al) from time to time. However, these will not be guaranteed, and holders of SZO will still need to purchase these discount coupons to be entitled to goods. 

In future, there are also plans to use the SZO token as a governance token to set rates. This may be in the form of participation in a voting process to determine the forex rates when offering the conversion of fiat currencies to DAI. 

	
# General Token Information

    - Standard ERC20
    - 18 decimals
    - 230,000,000 SZO pre-minted
    - token_price represents the starting sale price that will be issued from the smart contract
	Only the Owner of the Smart Contract can adjust the token price in the smart contract
	The token price has a min floor price of 0.0004Eth per SZO

The SZO token is priced to the ethereum gasnetwork gwei. Every SZO is backed by eth thats locked in the smart contract, only a ShuttleOne user with the KYCed owner can unlock eth during a transaction initiated by the user to pay for gas.

# Token Generation & General Metrics

96.8mil SZO will be preminted and locked for 12months. This is distributed to the early team members, equity holders and genesis users (users who participated in our pilot tests).

The tokens locked cannot be transfered out during the lockUP period or transacted.

Tokens under this premint will not be used for fee but redemption from ShuttleOne which we will utilize firstRedemption. ShuttleOne thereafter burns all the SZO.

# Token Burning & Utility 

Total token supply for utility in this contract is 133.2mil SZO, there is a 5% inflation per year after the issuance of all the tokens in the genesis round. The inflation conditions will only intiate after all tokens are issued and tied to minting conditions:

	1. Opening of ShuttleOne wallets
	
	2. Unique KYC verified onchain
	
	3. Top up of wallet is done

ShuttleOne calculates profits(or loss) as token_price minus tokenRedeem with the excess in digital assets sent to a custody of ShuttleOne that would be used during extreme price volatility of eth or SZO prices and firstRedemption event.
internalTransfer from wallet to wallet (i.e kyced users) is barred from the smart contract.

Should there be an excess of SZO/gwei, excess SZO will be burnt through each transaction.


