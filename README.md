# ATM Simulation Program

## Overview
This is an x86 Assembly language implementation of a simple ATM (Automated Teller Machine) simulation program designed to run in DOS environment. The program provides basic banking functionalities such as balance checking, money withdrawal, and deposit.

## Features
- Secure login with account number and password validation
- Balance inquiry
- Money withdrawal with limit checks
- Money deposit with amount validation
- User-friendly menu-driven interface

## Technical Specifications
- **Language**: x86 Assembly
- **Platform**: DOS
- **Assembler**: ASM 
- **Memory Model**: Small Memory Model

## Functional Workflow

### 1. Login Process
- User prompted to enter account number
- Account number validation
- Password input with '*' masking
- Authentication required for access

### 2. Main Menu Options
1. Check Balance
2. Withdraw Money
3. Deposit Money
4. Exit

## Input Validation
- Account number verification
- Password character-by-character matching
- Withdrawal and deposit amount range checks
- Input sanitization for numeric entries

## Limitations
- Fixed account number: 12345
- Fixed password: 1234
- Single account simulation
- Maximum deposit/withdrawal: Rs. 5000
- Minimum transaction: Rs. 100

## System Requirements
- x86 processor
- DOS operating system

## Code Structure
- `.model small`: Specifies small memory model
- `.stack 100h`: Allocates stack space
- `.data`: Data segment for variables
- `.code`: Code segment with procedures

## Key Procedures
- `validate_pass`: Password verification
- `take_amount`: Numeric input handling
- `display_data`: Number display routine
- `withdraw`: Money withdrawal logic
- `deposit`: Money deposit logic

## Error Handling
- Invalid account number
- Incorrect password
- Out-of-range transaction amounts
- Insufficient balance

## Potential Improvements
- Multiple account support

## Disclaimer
This is an educational project demonstrating basic assembly language programming concepts in a banking simulation context.

## Author
- Jaffar Kazmi

## Educational Objectives
- 3rd Semester (BSCS)
- COAL Project
- Demonstrate x86 assembly programming
- Showcase interrupt-based I/O
- Illustrate procedural programming in assembly
- Provide a practical simulation of a banking system
