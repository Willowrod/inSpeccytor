//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/10/2020.
//

import Foundation

class Z80 {
    
    func opCode(code: String) -> OpCode {
        
        switch(code.uppercased()){
        case "00":
            return OpCode(v: code, c: "NOP", m: "No Operation", l: 1)
        case "01":
            return OpCode(v: code, c: "LD BC,$$", m: "Load register pair BC with the value $$", l: 3, t: .DATA)
        case "02":
            return OpCode(v: code, c: "LD (BC),A", m: "Load the contents of the memory address stored in BC with the value of register A", l: 1)
            
        case "18":
            return OpCode(v: code, c: "JR ##", m: "Jump to routine at memory offset 2s $$ (##)", l: 2, e: true, t: .RELATIVE)
            
        case "21":
            return OpCode(v: code, c: "LD HL,$$", m: "Load the register pair HL with the value $$", l: 3, t: .DATA)
            
            
        case "28":
            return OpCode(v: code, c: "JR Z, ##", m: "If the Zero flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
            
        case "3E":
            return OpCode(v: code, c: "LD A,$$", m: "Load register A with the value $$", l: 2, t: .DATA)
            
        case "47":
            return OpCode(v: code, c: "LD B,A", m: "Load register B with the value of register A", l: 1)
            
        case "78":
            return OpCode(v: code, c: "LD A,B", m: "Load register A with the value of register B", l: 1)
            
        case "C3":
            return OpCode(v: code, c: "JP $$", m: "Jump to routine at memory location $$", l: 3, e: true, t: .CODE)
            
        case "CA":
            return OpCode(v: code, c: "JP Z, $$", m: "If the Zero flag is set in register F, jump to routine at memory location $$", l: 3, t: .CODE)
        case "CB":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "DB":
            return OpCode(v: code, c: "IN A,(±)", m: "Load register A with an input defined by the current value of A from port $$ (Generally keyboard input) ", l: 2, t: .VALUE)
            
        case "DD":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "E6":
            return OpCode(v: code, c: "AND ±", m: "Update A to only contain bytes set in both A and the value ±", l: 2)
            
        case "ED":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
        case "FD":
            return OpCode(v: code, c: "PreCode", m: "", l: 0)
            
            //DD Op codes
        case "DD21":
            return OpCode(v: code, c: "LD IX,$$", m: "Load the memory location IX with the value $$", l: 3, t: .DATA)
        case "DD36":
            return OpCode(v: code, c: "LD (IX+$1),$2", m: "Load the contents of the memory address stored in (IX + $1) with the value $2", l: 3, t: .DATA)
        case "03":
        return OpCode(v: code, c: "INC BC", m: " ", l: 1)
        case "04":
        return OpCode(v: code, c: "INC B", m: " ", l: 1)
        case "05":
        return OpCode(v: code, c: "DEC B", m: " ", l: 1)
        case "06":
        return OpCode(v: code, c: "LD B,±", m: " ", l: 2)
        case "07":
        return OpCode(v: code, c: "RLC A", m: " ", l: 1)
        case "08":
        return OpCode(v: code, c: "EX AF,AF'", m: " ", l: 1)
        case "09":
        return OpCode(v: code, c: "ADD HL,BC", m: " ", l: 1)
        case "0A":
        return OpCode(v: code, c: "LD A,(BC)", m: " ", l: 1)
        case "0B":
        return OpCode(v: code, c: "DEC BC", m: " ", l: 1)
        case "0C":
        return OpCode(v: code, c: "INC C", m: " ", l: 1)
        case "0D":
        return OpCode(v: code, c: "DEC C", m: " ", l: 1)
        case "0E":
        return OpCode(v: code, c: "LD C,±", m: " ", l: 2)
        case "0F":
        return OpCode(v: code, c: "RRC A", m: " ", l: 1)
        case "10":
        return OpCode(v: code, c: "DJNZ##", m: " ", l: 2, t: .RELATIVE)
        case "11":
        return OpCode(v: code, c: "LD DE,$$", m: " ", l: 3, t: .DATA)
        case "12":
        return OpCode(v: code, c: "LD (DE),A", m: " ", l: 1)
        case "13":
        return OpCode(v: code, c: "INC DE", m: " ", l: 1)
        case "14":
        return OpCode(v: code, c: "INC D", m: " ", l: 1)
        case "15":
        return OpCode(v: code, c: "DEC D", m: " ", l: 1)
        case "16":
        return OpCode(v: code, c: "LD D,±", m: " ", l: 2)
        case "17":
        return OpCode(v: code, c: "RL A", m: " ", l: 1)
        case "19":
        return OpCode(v: code, c: "ADD HL,DE", m: " ", l: 1)
        case "1A":
        return OpCode(v: code, c: "LD A,(DE)", m: " ", l: 1)
        case "1B":
        return OpCode(v: code, c: "DEC DE", m: " ", l: 1)
        case "1C":
        return OpCode(v: code, c: "INC E", m: " ", l: 1)
        case "1D":
        return OpCode(v: code, c: "DEC E", m: " ", l: 1)
        case "1E":
        return OpCode(v: code, c: "LD E,±", m: " ", l: 2)
        case "1F":
        return OpCode(v: code, c: "RRA", m: " ", l: 1)
        case "20":
        return OpCode(v: code, c: "JR NZ, ##", m: "If the Zero flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        case "22":
        return OpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
        case "23":
        return OpCode(v: code, c: "INC HL", m: " ", l: 1)
        case "24":
        return OpCode(v: code, c: "INC H", m: " ", l: 1)
        case "25":
        return OpCode(v: code, c: "DEC H", m: " ", l: 1)
        case "26":
        return OpCode(v: code, c: "LD H,$$", m: " ", l: 2, t: .DATA)
        case "27":
        return OpCode(v: code, c: "DAA", m: " ", l: 1)
        case "29":
        return OpCode(v: code, c: "ADD HL,HL", m: " ", l: 1)
        case "2A":
        return OpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
        case "2B":
        return OpCode(v: code, c: "DEC HL", m: " ", l: 1)
        case "2C":
        return OpCode(v: code, c: "INC L", m: " ", l: 1)
        case "2D":
        return OpCode(v: code, c: "DEC L", m: " ", l: 1)
        case "2E":
        return OpCode(v: code, c: "LD L,±", m: " ", l: 2)
        case "2F":
        return OpCode(v: code, c: "CP L", m: " ", l: 1)
        case "30":
        return OpCode(v: code, c: "JR NC, ##", m: "If the Carry flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        case "31":
        return OpCode(v: code, c: "LD SP,$$", m: " ", l: 3, t: .DATA)
        case "32":
        return OpCode(v: code, c: "LD ($$),A", m: " ", l: 3, t: .DATA)
        case "33":
        return OpCode(v: code, c: "INC SP", m: " ", l: 1)
        case "34":
        return OpCode(v: code, c: "INC (HL)", m: " ", l: 1)
        case "35":
        return OpCode(v: code, c: "DEC (HL)", m: " ", l: 1)
        case "36":
        return OpCode(v: code, c: "LD (HL),$$", m: " ", l: 3, t: .DATA)
        case "37":
        return OpCode(v: code, c: "SCF", m: " ", l: 1)
        case "38":
        return OpCode(v: code, c: "JR C, ##", m: "If the Carry flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        case "39":
        return OpCode(v: code, c: "ADD HL,SP", m: " ", l: 1)
        case "3A":
        return OpCode(v: code, c: "LD A,($$)", m: " ", l: 3, t: .DATA)
        case "3B":
        return OpCode(v: code, c: "DEC SP", m: " ", l: 1)
        case "3C":
        return OpCode(v: code, c: "INC A", m: " ", l: 1)
        case "3D":
        return OpCode(v: code, c: "DEC A", m: " ", l: 1)
        case "3F":
        return OpCode(v: code, c: "CCF", m: " ", l: 1)
        case "40":
        return OpCode(v: code, c: "LD B,B", m: " ", l: 1)
        case "41":
        return OpCode(v: code, c: "LD B,C", m: " ", l: 1)
        case "42":
        return OpCode(v: code, c: "LD B,D", m: " ", l: 1)
        case "43":
        return OpCode(v: code, c: "LD B,E", m: " ", l: 1)
        case "44":
        return OpCode(v: code, c: "LD B,H", m: " ", l: 1)
        case "45":
        return OpCode(v: code, c: "LD B,L", m: " ", l: 1)
        case "46":
        return OpCode(v: code, c: "LD B,(HL)", m: " ", l: 1)
        case "48":
        return OpCode(v: code, c: "LD C,B", m: " ", l: 1)
        case "49":
        return OpCode(v: code, c: "LD C,C", m: " ", l: 1)
        case "4A":
        return OpCode(v: code, c: "LD C,D", m: " ", l: 1)
        case "4B":
        return OpCode(v: code, c: "LD C,E", m: " ", l: 1)
        case "4C":
        return OpCode(v: code, c: "LD C,H", m: " ", l: 1)
        case "4D":
        return OpCode(v: code, c: "LD C,L", m: " ", l: 1)
        case "4E":
        return OpCode(v: code, c: "LD C,(HL)", m: " ", l: 1)
        case "4F":
        return OpCode(v: code, c: "LD C,A", m: " ", l: 1)
        case "50":
        return OpCode(v: code, c: "LD D,B", m: " ", l: 1)
        case "51":
        return OpCode(v: code, c: "LD D,C", m: " ", l: 1)
        case "52":
        return OpCode(v: code, c: "LD D,D", m: " ", l: 1)
        case "53":
        return OpCode(v: code, c: "LD D,E", m: " ", l: 1)
        case "54":
        return OpCode(v: code, c: "LD D,H", m: " ", l: 1)
        case "55":
        return OpCode(v: code, c: "LD D,L", m: " ", l: 1)
        case "56":
        return OpCode(v: code, c: "LD D,(HL)", m: " ", l: 1)
        case "57":
        return OpCode(v: code, c: "LD D,A", m: " ", l: 1)
        case "58":
        return OpCode(v: code, c: "LD E,B", m: " ", l: 1)
        case "59":
        return OpCode(v: code, c: "LD E,C", m: " ", l: 1)
        case "5A":
        return OpCode(v: code, c: "LD E,D", m: " ", l: 1)
        case "5B":
        return OpCode(v: code, c: "LD E,E", m: " ", l: 1)
        case "5C":
        return OpCode(v: code, c: "LD E,H", m: " ", l: 1)
        case "5D":
        return OpCode(v: code, c: "LD E,L", m: " ", l: 1)
        case "5E":
        return OpCode(v: code, c: "LD E,(HL)", m: " ", l: 1)
        case "5F":
        return OpCode(v: code, c: "LD E,A", m: " ", l: 1)
        case "60":
        return OpCode(v: code, c: "LD H,B", m: " ", l: 1)
        case "61":
        return OpCode(v: code, c: "LD H,C", m: " ", l: 1)
        case "62":
        return OpCode(v: code, c: "LD H,D", m: " ", l: 1)
        case "63":
        return OpCode(v: code, c: "LD H,E", m: " ", l: 1)
        case "64":
        return OpCode(v: code, c: "LD H,H", m: " ", l: 1)
        case "65":
        return OpCode(v: code, c: "LD H,L", m: " ", l: 1)
        case "66":
        return OpCode(v: code, c: "LD H,(HL)", m: " ", l: 1)
        case "67":
        return OpCode(v: code, c: "LD H,A", m: " ", l: 1)
        case "68":
        return OpCode(v: code, c: "LD L,B", m: " ", l: 1)
        case "69":
        return OpCode(v: code, c: "LD L,C", m: " ", l: 1)
        case "6A":
        return OpCode(v: code, c: "LD L,D", m: " ", l: 1)
        case "6B":
        return OpCode(v: code, c: "LD L,E", m: " ", l: 1)
        case "6C":
        return OpCode(v: code, c: "LD L,H", m: " ", l: 1)
        case "6D":
        return OpCode(v: code, c: "LD L,L", m: " ", l: 1)
        case "6E":
        return OpCode(v: code, c: "LD L,(HL)", m: " ", l: 1)
        case "6F":
        return OpCode(v: code, c: "LD L,A", m: " ", l: 1)
        case "70":
        return OpCode(v: code, c: "LD (HL),B", m: " ", l: 1)
        case "71":
        return OpCode(v: code, c: "LD (HL),C", m: " ", l: 1)
        case "72":
        return OpCode(v: code, c: "LD (HL),D", m: " ", l: 1)
        case "73":
        return OpCode(v: code, c: "LD (HL),E", m: " ", l: 1)
        case "74":
        return OpCode(v: code, c: "LD (HL),H", m: " ", l: 1)
        case "75":
        return OpCode(v: code, c: "LD (HL),L", m: " ", l: 1)
        case "76":
        return OpCode(v: code, c: "HALT", m: " ", l: 1)
        case "77":
        return OpCode(v: code, c: "LD (HL),A", m: " ", l: 1)
        case "79":
        return OpCode(v: code, c: "LD A,C", m: " ", l: 1)
        case "7A":
        return OpCode(v: code, c: "LD A,D", m: " ", l: 1)
        case "7B":
        return OpCode(v: code, c: "LD A,E", m: " ", l: 1)
        case "7C":
        return OpCode(v: code, c: "LD A,H", m: " ", l: 1)
        case "7D":
        return OpCode(v: code, c: "LD A,L", m: " ", l: 1)
        case "7E":
        return OpCode(v: code, c: "LD A,(HL)", m: " ", l: 1)
        case "7F":
        return OpCode(v: code, c: "LD A,A", m: " ", l: 1)
        case "80":
        return OpCode(v: code, c: "ADD A,B", m: " ", l: 1)
        case "81":
        return OpCode(v: code, c: "ADD A,C", m: " ", l: 1)
        case "82":
        return OpCode(v: code, c: "ADD A,D", m: " ", l: 1)
        case "83":
        return OpCode(v: code, c: "ADD A,E", m: " ", l: 1)
        case "84":
        return OpCode(v: code, c: "ADD A,H", m: " ", l: 1)
        case "85":
        return OpCode(v: code, c: "ADD A,L", m: " ", l: 1)
        case "86":
        return OpCode(v: code, c: "ADD A,(HL)", m: " ", l: 1)
        case "87":
        return OpCode(v: code, c: "ADD A,A", m: " ", l: 1)
        case "88":
        return OpCode(v: code, c: "ADC A,B", m: " ", l: 1)
        case "89":
        return OpCode(v: code, c: "ADC A,C", m: " ", l: 1)
        case "8A":
        return OpCode(v: code, c: "ADC A,D", m: " ", l: 1)
        case "8B":
        return OpCode(v: code, c: "ADC A,E", m: " ", l: 1)
        case "8C":
        return OpCode(v: code, c: "ADC A,H", m: " ", l: 1)
        case "8D":
        return OpCode(v: code, c: "ADC A,L", m: " ", l: 1)
        case "8E":
        return OpCode(v: code, c: "ADC A,(HL)", m: " ", l: 1)
        case "8F":
        return OpCode(v: code, c: "ADC A,A", m: " ", l: 1)
        case "90":
        return OpCode(v: code, c: "SUB A,B", m: " ", l: 1)
        case "91":
        return OpCode(v: code, c: "SUB A,C", m: " ", l: 1)
        case "92":
        return OpCode(v: code, c: "SUB A,D", m: " ", l: 1)
        case "93":
        return OpCode(v: code, c: "SUB A,E", m: " ", l: 1)
        case "94":
        return OpCode(v: code, c: "SUB A,H", m: " ", l: 1)
        case "95":
        return OpCode(v: code, c: "SUB A,L", m: " ", l: 1)
        case "96":
        return OpCode(v: code, c: "SUB A,(HL)", m: " ", l: 1)
        case "97":
        return OpCode(v: code, c: "SUB A,A", m: " ", l: 1)
        case "98":
        return OpCode(v: code, c: "SBC A,B", m: " ", l: 1)
        case "99":
        return OpCode(v: code, c: "SBC A,C", m: " ", l: 1)
        case "9A":
        return OpCode(v: code, c: "SBC A,D", m: " ", l: 1)
        case "9B":
        return OpCode(v: code, c: "SBC A,E", m: " ", l: 1)
        case "9C":
        return OpCode(v: code, c: "SBC A,H", m: " ", l: 1)
        case "9D":
        return OpCode(v: code, c: "SBC A,L", m: " ", l: 1)
        case "9E":
        return OpCode(v: code, c: "SBC A,(HL)", m: " ", l: 1)
        case "9F":
        return OpCode(v: code, c: "SBC A,A", m: " ", l: 1)
        case "A0":
        return OpCode(v: code, c: "AND B", m: " ", l: 1)
        case "A1":
        return OpCode(v: code, c: "AND C", m: " ", l: 1)
        case "A2":
        return OpCode(v: code, c: "AND D", m: " ", l: 1)
        case "A3":
        return OpCode(v: code, c: "AND E", m: " ", l: 1)
        case "A4":
        return OpCode(v: code, c: "AND H", m: " ", l: 1)
        case "A5":
        return OpCode(v: code, c: "AND L", m: " ", l: 1)
        case "A6":
        return OpCode(v: code, c: "AND (HL)", m: " ", l: 1)
        case "A7":
        return OpCode(v: code, c: "AND A", m: " ", l: 1)
        case "A8":
        return OpCode(v: code, c: "XOR B", m: " ", l: 1)
        case "A9":
        return OpCode(v: code, c: "XOR C", m: " ", l: 1)
        case "AA":
        return OpCode(v: code, c: "XOR D", m: " ", l: 1)
        case "AB":
        return OpCode(v: code, c: "XOR E", m: " ", l: 1)
        case "AC":
        return OpCode(v: code, c: "XOR H", m: " ", l: 1)
        case "AD":
        return OpCode(v: code, c: "XOR L", m: " ", l: 1)
        case "AE":
        return OpCode(v: code, c: "XOR (HL)", m: " ", l: 1)
        case "AF":
        return OpCode(v: code, c: "XOR A", m: " ", l: 1)
        case "B0":
        return OpCode(v: code, c: "OR B", m: " ", l: 1)
        case "B1":
        return OpCode(v: code, c: "OR C", m: " ", l: 1)
        case "B2":
        return OpCode(v: code, c: "OR D", m: " ", l: 1)
        case "B3":
        return OpCode(v: code, c: "OR E", m: " ", l: 1)
        case "B4":
        return OpCode(v: code, c: "OR H", m: " ", l: 1)
        case "B5":
        return OpCode(v: code, c: "OR L", m: " ", l: 1)
        case "B6":
        return OpCode(v: code, c: "OR (HL)", m: " ", l: 1)
        case "B7":
        return OpCode(v: code, c: "OR A", m: " ", l: 1)
        case "B8":
        return OpCode(v: code, c: "CP B", m: " ", l: 1)
        case "B9":
        return OpCode(v: code, c: "CP C", m: " ", l: 1)
        case "BA":
        return OpCode(v: code, c: "CP D", m: " ", l: 1)
        case "BB":
        return OpCode(v: code, c: "CP E", m: " ", l: 1)
        case "BC":
        return OpCode(v: code, c: "CP H", m: " ", l: 1)
        case "BD":
        return OpCode(v: code, c: "CP L", m: " ", l: 1)
        case "BE":
        return OpCode(v: code, c: "CP (HL)", m: " ", l: 1)
        case "BF":
        return OpCode(v: code, c: "CP A", m: " ", l: 1)
        case "C0":
        return OpCode(v: code, c: "RET NZ", m: " ", l: 1)
        case "C1":
        return OpCode(v: code, c: "POP BC", m: " ", l: 1)
        case "C2":
        return OpCode(v: code, c: "JP NZ,$$", m: " ", l: 3, t: .CODE)
        case "C4":
        return OpCode(v: code, c: "CALL NZ,$$", m: " ", l: 3, t: .CODE)
        case "C5":
        return OpCode(v: code, c: "PUSH BC", m: " ", l: 1)
        case "C6":
        return OpCode(v: code, c: "ADD A,±", m: " ", l: 2)
        case "C7":
        return OpCode(v: code, c: "RST 0", m: " ", l: 1)
        case "C8":
            return OpCode(v: code, c: "RET Z", m: " ", l: 1)
        case "C9":
        return OpCode(v: code, c: "RET", m: " ", l: 1, e: true)
        case "CC":
        return OpCode(v: code, c: "CALL Z,$$", m: " ", l: 3, t: .CODE)
        case "CD":
        return OpCode(v: code, c: "CALL $$", m: " ", l: 3, t: .CODE)
        case "CE":
        return OpCode(v: code, c: "ADC A,±", m: " ", l: 2)
        case "CF":
        return OpCode(v: code, c: "RST &08", m: " ", l: 1)
        case "D0":
        return OpCode(v: code, c: "RET NC", m: " ", l: 1)
        case "D1":
        return OpCode(v: code, c: "POP DE", m: " ", l: 1)
        case "D2":
        return OpCode(v: code, c: "JP NC,$$", m: " ", l: 3, t: .CODE)
        case "D3":
        return OpCode(v: code, c: "OUT (±),A", m: " ", l: 2)
        case "D4":
        return OpCode(v: code, c: "CALL NC,$$", m: " ", l: 3, t: .CODE)
        case "D5":
        return OpCode(v: code, c: "PUSH DE", m: " ", l: 1)
        case "D6":
        return OpCode(v: code, c: "SUB A,±", m: " ", l: 2)
        case "D7":
        return OpCode(v: code, c: "RST &10", m: " ", l: 1)
        case "D8":
        return OpCode(v: code, c: "RET C", m: " ", l: 1)
        case "D9":
        return OpCode(v: code, c: "EXX", m: " ", l: 1)
        case "DA":
        return OpCode(v: code, c: "JP C,$$", m: " ", l: 3, t: .CODE)
        case "DC":
        return OpCode(v: code, c: "CALL C,$$", m: " ", l: 3, t: .CODE)
        case "DE":
        return OpCode(v: code, c: "SBC A,±", m: " ", l: 2)
        case "DF":
        return OpCode(v: code, c: "RST &18", m: " ", l: 1)
        case "E0":
        return OpCode(v: code, c: "RET PO", m: " ", l: 1)
        case "E1":
        return OpCode(v: code, c: "POP HL", m: " ", l: 1)
        case "E2":
        return OpCode(v: code, c: "JP PO,$$", m: " ", l: 3, t: .CODE)
        case "E3":
        return OpCode(v: code, c: "EX (SP),HL", m: " ", l: 1)
        case "E4":
        return OpCode(v: code, c: "CALL PO,$$", m: " ", l: 3, t: .CODE)
        case "E5":
        return OpCode(v: code, c: "PUSH HL", m: " ", l: 1)
        case "E7":
        return OpCode(v: code, c: "RST &20", m: " ", l: 1)
        case "E8":
        return OpCode(v: code, c: "RET PE", m: " ", l: 1)
        case "E9":
        return OpCode(v: code, c: "JP (HL)", m: " ", l: 1)
        case "EA":
        return OpCode(v: code, c: "JP PE,$$", m: " ", l: 3, t: .CODE)
        case "EB":
        return OpCode(v: code, c: "EX DE,HL", m: " ", l: 1)
        case "EC":
        return OpCode(v: code, c: "CALL PE,$$", m: " ", l: 3, t: .CODE)
        case "EE":
        return OpCode(v: code, c: "XOR ±", m: " ", l: 2)
        case "EF":
        return OpCode(v: code, c: "RST &28", m: " ", l: 1)
        case "F0":
        return OpCode(v: code, c: "RET P", m: " ", l: 1)
        case "F1":
        return OpCode(v: code, c: "POP AF", m: " ", l: 1)
        case "F2":
        return OpCode(v: code, c: "JP P,$$", m: " ", l: 3, t: .CODE)
        case "F3":
        return OpCode(v: code, c: "DI", m: " ", l: 1)
        case "F4":
        return OpCode(v: code, c: "CALL P,$$", m: " ", l: 3, t: .CODE)
        case "F5":
        return OpCode(v: code, c: "PUSH AF", m: " ", l: 1)
        case "F6":
        return OpCode(v: code, c: "OR ±", m: " ", l: 2)
        case "F7":
        return OpCode(v: code, c: "RST &30", m: " ", l: 1)
        case "F8":
        return OpCode(v: code, c: "RET M", m: " ", l: 1)
        case "F9":
        return OpCode(v: code, c: "LD SP,HL", m: " ", l: 1)
        case "FA":
        return OpCode(v: code, c: "JP M,$$", m: " ", l: 3, t: .CODE)
        case "FB":
        return OpCode(v: code, c: "EI", m: " ", l: 1)
        case "FC":
        return OpCode(v: code, c: "CALL M,$$", m: " ", l: 3, t: .CODE)
        case "FE":
        return OpCode(v: code, c: "CP ±", m: " ", l: 2)
        case "FF":
        return OpCode(v: code, c: "RST &38", m: " ", l: 1)
        case "DD09":
        return OpCode(v: code, c: "ADD IX,BC", m: " ", l: 1)
        case "DD19":
        return OpCode(v: code, c: "ADD IX,DE", m: " ", l: 1)
        case "DD22":
        return OpCode(v: code, c: "LD ($$),IX", m: " ", l: 3, t: .DATA)
        case "DD23":
        return OpCode(v: code, c: "INC IX", m: " ", l: 1)
        case "DD24":
        return OpCode(v: code, c: "INC IXH", m: " ", l: 1)
        case "DD25":
        return OpCode(v: code, c: "DEC IXH", m: " ", l: 1)
        case "DD26":
        return OpCode(v: code, c: "LD IXH,±", m: " ", l: 2)
        case "DD29":
        return OpCode(v: code, c: "ADD IX,IX", m: " ", l: 1)
        case "DD2A":
        return OpCode(v: code, c: "LD IX,($$)", m: " ", l: 3, t: .DATA)
        case "DD2B":
        return OpCode(v: code, c: "DEC IX", m: " ", l: 1)
        case "DD2C":
        return OpCode(v: code, c: "INC IXL", m: " ", l: 1)
        case "DD2D":
        return OpCode(v: code, c: "DEC IXL", m: " ", l: 1)
        case "DD2E":
        return OpCode(v: code, c: "LD IXL,±", m: " ", l: 2)
        case "DD34":
        return OpCode(v: code, c: "INC (IX+0)", m: " ", l: 1)
        case "DD35":
        return OpCode(v: code, c: "DEC (IX+0)", m: " ", l: 1)
        case "DD39":
        return OpCode(v: code, c: "ADD IX,SP", m: " ", l: 1)
        case "DD44":
        return OpCode(v: code, c: "LD B,IXH", m: " ", l: 1)
        case "DD45":
        return OpCode(v: code, c: "LD B,IXL", m: " ", l: 1)
        case "DD46":
        return OpCode(v: code, c: "LD B,(IX+0)", m: " ", l: 1)
        case "DD4C":
        return OpCode(v: code, c: "LD C,IXH", m: " ", l: 1)
        case "DD4D":
        return OpCode(v: code, c: "LD C,IXL", m: " ", l: 1)
        case "DD4E":
        return OpCode(v: code, c: "LD C,(IX+0)", m: " ", l: 1)
        case "DD54":
        return OpCode(v: code, c: "LD D,IXH", m: " ", l: 1)
        case "DD55":
        return OpCode(v: code, c: "LD D,IXL", m: " ", l: 1)
        case "DD56":
        return OpCode(v: code, c: "LD D,(IX+0)", m: " ", l: 1)
        case "DD5C":
        return OpCode(v: code, c: "LD E,IXH", m: " ", l: 1)
        case "DD5D":
        return OpCode(v: code, c: "LD E,IXL", m: " ", l: 1)
        case "DD5E":
        return OpCode(v: code, c: "LD E,(IX+0)", m: " ", l: 1)
        case "DD60":
        return OpCode(v: code, c: "LD IXH,B", m: " ", l: 1)
        case "DD61":
        return OpCode(v: code, c: "LD IXH,C", m: " ", l: 1)
        case "DD62":
        return OpCode(v: code, c: "LD IXH,D", m: " ", l: 1)
        case "DD63":
        return OpCode(v: code, c: "LD IXH,E", m: " ", l: 1)
        case "DD64":
        return OpCode(v: code, c: "LD IXH,IXH", m: " ", l: 1)
        case "DD65":
        return OpCode(v: code, c: "LD IXH,IXL", m: " ", l: 1)
        case "DD66":
        return OpCode(v: code, c: "LD H,(IX+0)", m: " ", l: 1)
        case "DD67":
        return OpCode(v: code, c: "LD IXH,A", m: " ", l: 1)
        case "DD68":
        return OpCode(v: code, c: "LD IXL,B", m: " ", l: 1)
        case "DD69":
        return OpCode(v: code, c: "LD IXL,C", m: " ", l: 1)
        case "DD6A":
        return OpCode(v: code, c: "LD IXL,D", m: " ", l: 1)
        case "DD6B":
        return OpCode(v: code, c: "LD IXL,E", m: " ", l: 1)
        case "DD6C":
        return OpCode(v: code, c: "LD IXL,IXH", m: " ", l: 1)
        case "DD6D":
        return OpCode(v: code, c: "LD IXL,IXL", m: " ", l: 1)
        case "DD6E":
        return OpCode(v: code, c: "LD L,(IX+0)", m: " ", l: 1)
        case "DD6F":
        return OpCode(v: code, c: "LD IXL,A", m: " ", l: 1)
        case "DD70":
        return OpCode(v: code, c: "LD (IX+0),B", m: " ", l: 1)
        case "DD71":
        return OpCode(v: code, c: "LD (IX+0),C", m: " ", l: 1)
        case "DD72":
        return OpCode(v: code, c: "LD (IX+0),D", m: " ", l: 1)
        case "DD73":
        return OpCode(v: code, c: "LD (IX+0),E", m: " ", l: 1)
        case "DD74":
        return OpCode(v: code, c: "LD (IX+0),H", m: " ", l: 1)
        case "DD75":
        return OpCode(v: code, c: "LD (IX+0),L", m: " ", l: 1)
        case "DD77":
        return OpCode(v: code, c: "LD (IX+0),A", m: " ", l: 1)
        case "DD7C":
        return OpCode(v: code, c: "LD A,IXH", m: " ", l: 1)
        case "DD7D":
        return OpCode(v: code, c: "LD A,IXL", m: " ", l: 1)
        case "DD7E":
        return OpCode(v: code, c: "LD A,(IX+0)", m: " ", l: 1)
        case "DD84":
        return OpCode(v: code, c: "ADD A,IXH", m: " ", l: 1)
        case "DD85":
        return OpCode(v: code, c: "ADD A,IXL", m: " ", l: 1)
        case "DD86":
        return OpCode(v: code, c: "ADD A,(IX+0)", m: " ", l: 1)
        case "DD8C":
        return OpCode(v: code, c: "ADC A,IXH", m: " ", l: 1)
        case "DD8D":
        return OpCode(v: code, c: "ADC A,IXL", m: " ", l: 1)
        case "DD8E":
        return OpCode(v: code, c: "ADC A,(IX+0)", m: " ", l: 1)
        case "DD94":
        return OpCode(v: code, c: "SUB A,IXH", m: " ", l: 1)
        case "DD95":
        return OpCode(v: code, c: "SUB A,IXL", m: " ", l: 1)
        case "DD96":
        return OpCode(v: code, c: "SUB A,(IX+0)", m: " ", l: 1)
        case "DD9C":
        return OpCode(v: code, c: "SBC A,IXH", m: " ", l: 1)
        case "DD9D":
        return OpCode(v: code, c: "SBC A,IXL", m: " ", l: 1)
        case "DD9E":
        return OpCode(v: code, c: "SBC A,(IX+0)", m: " ", l: 1)
        case "DDA4":
        return OpCode(v: code, c: "AND IXH", m: " ", l: 1)
        case "DDA5":
        return OpCode(v: code, c: "AND IXL", m: " ", l: 1)
        case "DDA6":
        return OpCode(v: code, c: "AND (IX+0)", m: " ", l: 1)
        case "DDAC":
        return OpCode(v: code, c: "XOR IXH", m: " ", l: 1)
        case "DDAD":
        return OpCode(v: code, c: "XOR IXL", m: " ", l: 1)
        case "DDAE":
        return OpCode(v: code, c: "XOR (IX+0)", m: " ", l: 1)
        case "DDB4":
        return OpCode(v: code, c: "OR IXH", m: " ", l: 1)
        case "DDB5":
        return OpCode(v: code, c: "OR IXL", m: " ", l: 1)
        case "DDB6":
        return OpCode(v: code, c: "OR (IX+0)", m: " ", l: 1)
        case "DDBC":
        return OpCode(v: code, c: "CP IXH", m: " ", l: 1)
        case "DDBD":
        return OpCode(v: code, c: "CP IXL", m: " ", l: 1)
        case "DDBE":
        return OpCode(v: code, c: "CP (IX+0)", m: " ", l: 1)
        case "DDE1":
        return OpCode(v: code, c: "POP IX", m: " ", l: 1)
        case "DDE3":
        return OpCode(v: code, c: "EX (SP),IX", m: " ", l: 1)
        case "DDE5":
        return OpCode(v: code, c: "PUSH IX", m: " ", l: 1)
        case "DDE9":
        return OpCode(v: code, c: "JP (IX)", m: " ", l: 1)
        case "CB00":
        return OpCode(v: code, c: "RLC B", m: " ", l: 1)
        case "CB01":
        return OpCode(v: code, c: "RLC C", m: " ", l: 1)
        case "CB02":
        return OpCode(v: code, c: "RLC D", m: " ", l: 1)
        case "CB03":
        return OpCode(v: code, c: "RLC E", m: " ", l: 1)
        case "CB04":
        return OpCode(v: code, c: "RLC H", m: " ", l: 1)
        case "CB05":
        return OpCode(v: code, c: "RLC L", m: " ", l: 1)
        case "CB06":
        return OpCode(v: code, c: "RLC (HL)", m: " ", l: 1)
        case "CB07":
        return OpCode(v: code, c: "RLC A", m: " ", l: 1)
        case "CB08":
        return OpCode(v: code, c: "RRC B", m: " ", l: 1)
        case "CB09":
        return OpCode(v: code, c: "RRC C", m: " ", l: 1)
        case "CB0A":
        return OpCode(v: code, c: "RRC D", m: " ", l: 1)
        case "CB0B":
        return OpCode(v: code, c: "RRC E", m: " ", l: 1)
        case "CB0C":
        return OpCode(v: code, c: "RRC H", m: " ", l: 1)
        case "CB0D":
        return OpCode(v: code, c: "RRC L", m: " ", l: 1)
        case "CB0E":
        return OpCode(v: code, c: "RRC (HL)", m: " ", l: 1)
        case "CB0F":
        return OpCode(v: code, c: "RRC A", m: " ", l: 1)
        case "CB10":
        return OpCode(v: code, c: "RL B", m: " ", l: 1)
        case "CB11":
        return OpCode(v: code, c: "RL C ", m: " ", l: 1)
        case "CB12":
        return OpCode(v: code, c: "RL D", m: " ", l: 1)
        case "CB13":
        return OpCode(v: code, c: "RL E", m: " ", l: 1)
        case "CB14":
        return OpCode(v: code, c: "RL H", m: " ", l: 1)
        case "CB15":
        return OpCode(v: code, c: "RL L", m: " ", l: 1)
        case "CB16":
        return OpCode(v: code, c: "RL (HL)", m: " ", l: 1)
        case "CB17":
        return OpCode(v: code, c: "RL A", m: " ", l: 1)
        case "CB18":
        return OpCode(v: code, c: "RR B", m: " ", l: 1)
        case "CB19":
        return OpCode(v: code, c: "RR C ", m: " ", l: 1)
        case "CB1A":
        return OpCode(v: code, c: "RR D", m: " ", l: 1)
        case "CB1B":
        return OpCode(v: code, c: "RR E", m: " ", l: 1)
        case "CB1C":
        return OpCode(v: code, c: "RR H", m: " ", l: 1)
        case "CB1D":
        return OpCode(v: code, c: "RR L", m: " ", l: 1)
        case "CB1E":
        return OpCode(v: code, c: "RR (HL)", m: " ", l: 1)
        case "CB1F":
        return OpCode(v: code, c: "RR A", m: " ", l: 1)
        case "CB20":
        return OpCode(v: code, c: "SLA B", m: " ", l: 1)
        case "CB21":
        return OpCode(v: code, c: "SLA C", m: " ", l: 1)
        case "CB22":
        return OpCode(v: code, c: "SLA D", m: " ", l: 1)
        case "CB23":
        return OpCode(v: code, c: "SLA E", m: " ", l: 1)
        case "CB24":
        return OpCode(v: code, c: "SLA H", m: " ", l: 1)
        case "CB25":
        return OpCode(v: code, c: "SLA L", m: " ", l: 1)
        case "CB26":
        return OpCode(v: code, c: "SLA (HL)", m: " ", l: 1)
        case "CB27":
        return OpCode(v: code, c: "SLA A", m: " ", l: 1)
        case "CB28":
        return OpCode(v: code, c: "SRA B", m: " ", l: 1)
        case "CB29":
        return OpCode(v: code, c: "SRA C", m: " ", l: 1)
        case "CB2A":
        return OpCode(v: code, c: "SRA D", m: " ", l: 1)
        case "CB2B":
        return OpCode(v: code, c: "SRA E", m: " ", l: 1)
        case "CB2C":
        return OpCode(v: code, c: "SRA H", m: " ", l: 1)
        case "CB2D":
        return OpCode(v: code, c: "SRA L", m: " ", l: 1)
        case "CB2E":
        return OpCode(v: code, c: "SRA (HL)", m: " ", l: 1)
        case "CB2F":
        return OpCode(v: code, c: "SRA A", m: " ", l: 1)
        case "CB30":
        return OpCode(v: code, c: "SLS B", m: " ", l: 1)
        case "CB31":
        return OpCode(v: code, c: "SLS C", m: " ", l: 1)
        case "CB32":
        return OpCode(v: code, c: "SLS D", m: " ", l: 1)
        case "CB33":
        return OpCode(v: code, c: "SLS E", m: " ", l: 1)
        case "CB34":
        return OpCode(v: code, c: "SLS H", m: " ", l: 1)
        case "CB35":
        return OpCode(v: code, c: "SLS L", m: " ", l: 1)
        case "CB36":
        return OpCode(v: code, c: "SLS (HL)", m: " ", l: 1)
        case "CB37":
        return OpCode(v: code, c: "SLS A", m: " ", l: 1)
        case "CB38":
        return OpCode(v: code, c: "SRL B", m: " ", l: 1)
        case "CB39":
        return OpCode(v: code, c: "SRL C", m: " ", l: 1)
        case "CB3A":
        return OpCode(v: code, c: "SRL D", m: " ", l: 1)
        case "CB3B":
        return OpCode(v: code, c: "SRL E", m: " ", l: 1)
        case "CB3C":
        return OpCode(v: code, c: "SRL H", m: " ", l: 1)
        case "CB3D":
        return OpCode(v: code, c: "SRL L", m: " ", l: 1)
        case "CB3E":
        return OpCode(v: code, c: "SRL (HL)", m: " ", l: 1)
        case "CB3F":
        return OpCode(v: code, c: "SRL A", m: " ", l: 1)
        case "CB40":
        return OpCode(v: code, c: "BIT 0,B", m: " ", l: 1)
        case "CB41":
        return OpCode(v: code, c: "BIT 0,C", m: " ", l: 1)
        case "CB42":
        return OpCode(v: code, c: "BIT 0,D", m: " ", l: 1)
        case "CB43":
        return OpCode(v: code, c: "BIT 0,E", m: " ", l: 1)
        case "CB44":
        return OpCode(v: code, c: "BIT 0,H", m: " ", l: 1)
        case "CB45":
        return OpCode(v: code, c: "BIT 0,L", m: " ", l: 1)
        case "CB46":
        return OpCode(v: code, c: "BIT 0,(HL)", m: " ", l: 1)
        case "CB47":
        return OpCode(v: code, c: "BIT 0,A", m: " ", l: 1)
        case "CB48":
        return OpCode(v: code, c: "BIT 1,B", m: " ", l: 1)
        case "CB49":
        return OpCode(v: code, c: "BIT 1,C", m: " ", l: 1)
        case "CB4A":
        return OpCode(v: code, c: "BIT 1,D", m: " ", l: 1)
        case "CB4B":
        return OpCode(v: code, c: "BIT 1,E", m: " ", l: 1)
        case "CB4C":
        return OpCode(v: code, c: "BIT 1,H", m: " ", l: 1)
        case "CB4D":
        return OpCode(v: code, c: "BIT 1,L", m: " ", l: 1)
        case "CB4E":
        return OpCode(v: code, c: "BIT 1,(HL)", m: " ", l: 1)
        case "CB4F":
        return OpCode(v: code, c: "BIT 1,A", m: " ", l: 1)
        case "CB50":
        return OpCode(v: code, c: "BIT 2,B", m: " ", l: 1)
        case "CB51":
        return OpCode(v: code, c: "BIT 2,C", m: " ", l: 1)
        case "CB52":
        return OpCode(v: code, c: "BIT 2,D", m: " ", l: 1)
        case "CB53":
        return OpCode(v: code, c: "BIT 2,E", m: " ", l: 1)
        case "CB54":
        return OpCode(v: code, c: "BIT 2,H", m: " ", l: 1)
        case "CB55":
        return OpCode(v: code, c: "BIT 2,L", m: " ", l: 1)
        case "CB56":
        return OpCode(v: code, c: "BIT 2,(HL)", m: " ", l: 1)
        case "CB57":
        return OpCode(v: code, c: "BIT 2,A", m: " ", l: 1)
        case "CB58":
        return OpCode(v: code, c: "BIT 3,B", m: " ", l: 1)
        case "CB59":
        return OpCode(v: code, c: "BIT 3,C", m: " ", l: 1)
        case "CB5A":
        return OpCode(v: code, c: "BIT 3,D", m: " ", l: 1)
        case "CB5B":
        return OpCode(v: code, c: "BIT 3,E", m: " ", l: 1)
        case "CB5C":
        return OpCode(v: code, c: "BIT 3,H", m: " ", l: 1)
        case "CB5D":
        return OpCode(v: code, c: "BIT 3,L", m: " ", l: 1)
        case "CB5E":
        return OpCode(v: code, c: "BIT 3,(HL)", m: " ", l: 1)
        case "CB5F":
        return OpCode(v: code, c: "BIT 3,A", m: " ", l: 1)
        case "CB60":
        return OpCode(v: code, c: "BIT 4,B", m: " ", l: 1)
        case "CB61":
        return OpCode(v: code, c: "BIT 4,C", m: " ", l: 1)
        case "CB62":
        return OpCode(v: code, c: "BIT 4,D", m: " ", l: 1)
        case "CB63":
        return OpCode(v: code, c: "BIT 4,E", m: " ", l: 1)
        case "CB64":
        return OpCode(v: code, c: "BIT 4,H", m: " ", l: 1)
        case "CB65":
        return OpCode(v: code, c: "BIT 4,L", m: " ", l: 1)
        case "CB66":
        return OpCode(v: code, c: "BIT 4,(HL)", m: " ", l: 1)
        case "CB67":
        return OpCode(v: code, c: "BIT 4,A", m: " ", l: 1)
        case "CB68":
        return OpCode(v: code, c: "BIT 5,B", m: " ", l: 1)
        case "CB69":
        return OpCode(v: code, c: "BIT 5,C", m: " ", l: 1)
        case "CB6A":
        return OpCode(v: code, c: "BIT 5,D", m: " ", l: 1)
        case "CB6B":
        return OpCode(v: code, c: "BIT 5,E", m: " ", l: 1)
        case "CB6C":
        return OpCode(v: code, c: "BIT 5,H", m: " ", l: 1)
        case "CB6D":
        return OpCode(v: code, c: "BIT 5,L", m: " ", l: 1)
        case "CB6E":
        return OpCode(v: code, c: "BIT 5,(HL)", m: " ", l: 1)
        case "CB6F":
        return OpCode(v: code, c: "BIT 5,A", m: " ", l: 1)
        case "CB70":
        return OpCode(v: code, c: "BIT 6,B", m: " ", l: 1)
        case "CB71":
        return OpCode(v: code, c: "BIT 6,C", m: " ", l: 1)
        case "CB72":
        return OpCode(v: code, c: "BIT 6,D", m: " ", l: 1)
        case "CB73":
        return OpCode(v: code, c: "BIT 6,E", m: " ", l: 1)
        case "CB74":
        return OpCode(v: code, c: "BIT 6,H", m: " ", l: 1)
        case "CB75":
        return OpCode(v: code, c: "BIT 6,L", m: " ", l: 1)
        case "CB76":
        return OpCode(v: code, c: "BIT 6,(HL)", m: " ", l: 1)
        case "CB77":
        return OpCode(v: code, c: "BIT 6,A", m: " ", l: 1)
        case "CB78":
        return OpCode(v: code, c: "BIT 7,B", m: " ", l: 1)
        case "CB79":
        return OpCode(v: code, c: "BIT 7,C", m: " ", l: 1)
        case "CB7A":
        return OpCode(v: code, c: "BIT 7,D", m: " ", l: 1)
        case "CB7B":
        return OpCode(v: code, c: "BIT 7,E", m: " ", l: 1)
        case "CB7C":
        return OpCode(v: code, c: "BIT 7,H", m: " ", l: 1)
        case "CB7D":
        return OpCode(v: code, c: "BIT 7,L", m: " ", l: 1)
        case "CB7E":
        return OpCode(v: code, c: "BIT 7,(HL)", m: " ", l: 1)
        case "CB7F":
        return OpCode(v: code, c: "BIT 7,A", m: " ", l: 1)
        case "CB80":
        return OpCode(v: code, c: "RES 0,B", m: " ", l: 1)
        case "CB81":
        return OpCode(v: code, c: "RES 0,C", m: " ", l: 1)
        case "CB82":
        return OpCode(v: code, c: "RES 0,D", m: " ", l: 1)
        case "CB83":
        return OpCode(v: code, c: "RES 0,E", m: " ", l: 1)
        case "CB84":
        return OpCode(v: code, c: "RES 0,H", m: " ", l: 1)
        case "CB85":
        return OpCode(v: code, c: "RES 0,L", m: " ", l: 1)
        case "CB86":
        return OpCode(v: code, c: "RES 0,(HL)", m: " ", l: 1)
        case "CB87":
        return OpCode(v: code, c: "RES 0,A", m: " ", l: 1)
        case "CB88":
        return OpCode(v: code, c: "RES 1,B", m: " ", l: 1)
        case "CB89":
        return OpCode(v: code, c: "RES 1,C", m: " ", l: 1)
        case "CB8A":
        return OpCode(v: code, c: "RES 1,D", m: " ", l: 1)
        case "CB8B":
        return OpCode(v: code, c: "RES 1,E", m: " ", l: 1)
        case "CB8C":
        return OpCode(v: code, c: "RES 1,H", m: " ", l: 1)
        case "CB8D":
        return OpCode(v: code, c: "RES 1,L", m: " ", l: 1)
        case "CB8E":
        return OpCode(v: code, c: "RES 1,(HL)", m: " ", l: 1)
        case "CB8F":
        return OpCode(v: code, c: "RES 1,A", m: " ", l: 1)
        case "CB90":
        return OpCode(v: code, c: "RES 2,B", m: " ", l: 1)
        case "CB91":
        return OpCode(v: code, c: "RES 2,C", m: " ", l: 1)
        case "CB92":
        return OpCode(v: code, c: "RES 2,D", m: " ", l: 1)
        case "CB93":
        return OpCode(v: code, c: "RES 2,E", m: " ", l: 1)
        case "CB94":
        return OpCode(v: code, c: "RES 2,H", m: " ", l: 1)
        case "CB95":
        return OpCode(v: code, c: "RES 2,L", m: " ", l: 1)
        case "CB96":
        return OpCode(v: code, c: "RES 2,(HL)", m: " ", l: 1)
        case "CB97":
        return OpCode(v: code, c: "RES 2,A", m: " ", l: 1)
        case "CB98":
        return OpCode(v: code, c: "RES 3,B", m: " ", l: 1)
        case "CB99":
        return OpCode(v: code, c: "RES 3,C", m: " ", l: 1)
        case "CB9A":
        return OpCode(v: code, c: "RES 3,D", m: " ", l: 1)
        case "CB9B":
        return OpCode(v: code, c: "RES 3,E", m: " ", l: 1)
        case "CB9C":
        return OpCode(v: code, c: "RES 3,H", m: " ", l: 1)
        case "CB9D":
        return OpCode(v: code, c: "RES 3,L", m: " ", l: 1)
        case "CB9E":
        return OpCode(v: code, c: "RES 3,(HL)", m: " ", l: 1)
        case "CB9F":
        return OpCode(v: code, c: "RES 3,A", m: " ", l: 1)
        case "CBA0":
        return OpCode(v: code, c: "RES 4,B", m: " ", l: 1)
        case "CBA1":
        return OpCode(v: code, c: "RES 4,C", m: " ", l: 1)
        case "CBA2":
        return OpCode(v: code, c: "RES 4,D", m: " ", l: 1)
        case "CBA3":
        return OpCode(v: code, c: "RES 4,E", m: " ", l: 1)
        case "CBA4":
        return OpCode(v: code, c: "RES 4,H", m: " ", l: 1)
        case "CBA5":
        return OpCode(v: code, c: "RES 4,L", m: " ", l: 1)
        case "CBA6":
        return OpCode(v: code, c: "RES 4,(HL)", m: " ", l: 1)
        case "CBA7":
        return OpCode(v: code, c: "RES 4,A", m: " ", l: 1)
        case "CBA8":
        return OpCode(v: code, c: "RES 5,B", m: " ", l: 1)
        case "CBA9":
        return OpCode(v: code, c: "RES 5,C", m: " ", l: 1)
        case "CBAA":
        return OpCode(v: code, c: "RES 5,D", m: " ", l: 1)
        case "CBAB":
        return OpCode(v: code, c: "RES 5,E", m: " ", l: 1)
        case "CBAC":
        return OpCode(v: code, c: "RES 5,H", m: " ", l: 1)
        case "CBAD":
        return OpCode(v: code, c: "RES 5,L", m: " ", l: 1)
        case "CBAE":
        return OpCode(v: code, c: "RES 5,(HL)", m: " ", l: 1)
        case "CBAF":
        return OpCode(v: code, c: "RES 5,A", m: " ", l: 1)
        case "CBB0":
        return OpCode(v: code, c: "RES 6,B", m: " ", l: 1)
        case "CBB1":
        return OpCode(v: code, c: "RES 6,C", m: " ", l: 1)
        case "CBB2":
        return OpCode(v: code, c: "RES 6,D", m: " ", l: 1)
        case "CBB3":
        return OpCode(v: code, c: "RES 6,E", m: " ", l: 1)
        case "CBB4":
        return OpCode(v: code, c: "RES 6,H", m: " ", l: 1)
        case "CBB5":
        return OpCode(v: code, c: "RES 6,L", m: " ", l: 1)
        case "CBB6":
        return OpCode(v: code, c: "RES 6,(HL)", m: " ", l: 1)
        case "CBB7":
        return OpCode(v: code, c: "RES 6,A", m: " ", l: 1)
        case "CBB8":
        return OpCode(v: code, c: "RES 7,B", m: " ", l: 1)
        case "CBB9":
        return OpCode(v: code, c: "RES 7,C", m: " ", l: 1)
        case "CBBA":
        return OpCode(v: code, c: "RES 7,D", m: " ", l: 1)
        case "CBBB":
        return OpCode(v: code, c: "RES 7,E", m: " ", l: 1)
        case "CBBC":
        return OpCode(v: code, c: "RES 7,H", m: " ", l: 1)
        case "CBBD":
        return OpCode(v: code, c: "RES 7,L", m: " ", l: 1)
        case "CBBE":
        return OpCode(v: code, c: "RES 7,(HL)", m: " ", l: 1)
        case "CBBF":
        return OpCode(v: code, c: "RES 7,A", m: " ", l: 1)
        case "CBC0":
        return OpCode(v: code, c: "SET 0,B", m: " ", l: 1)
        case "CBC1":
        return OpCode(v: code, c: "SET 0,C", m: " ", l: 1)
        case "CBC2":
        return OpCode(v: code, c: "SET 0,D", m: " ", l: 1)
        case "CBC3":
        return OpCode(v: code, c: "SET 0,E", m: " ", l: 1)
        case "CBC4":
        return OpCode(v: code, c: "SET 0,H", m: " ", l: 1)
        case "CBC5":
        return OpCode(v: code, c: "SET 0,L", m: " ", l: 1)
        case "CBC6":
        return OpCode(v: code, c: "SET 0,(HL)", m: " ", l: 1)
        case "CBC7":
        return OpCode(v: code, c: "SET 0,A", m: " ", l: 1)
        case "CBC8":
        return OpCode(v: code, c: "SET 1,B", m: " ", l: 1)
        case "CBC9":
        return OpCode(v: code, c: "SET 1,C", m: " ", l: 1)
        case "CBCA":
        return OpCode(v: code, c: "SET 1,D", m: " ", l: 1)
        case "CBCB":
        return OpCode(v: code, c: "SET 1,E", m: " ", l: 1)
        case "CBCC":
        return OpCode(v: code, c: "SET 1,H", m: " ", l: 1)
        case "CBCD":
        return OpCode(v: code, c: "SET 1,L", m: " ", l: 1)
        case "CBCE":
        return OpCode(v: code, c: "SET 1,(HL)", m: " ", l: 1)
        case "CBCF":
        return OpCode(v: code, c: "SET 1,A", m: " ", l: 1)
        case "CBD0":
        return OpCode(v: code, c: "SET 2,B", m: " ", l: 1)
        case "CBD1":
        return OpCode(v: code, c: "SET 2,C", m: " ", l: 1)
        case "CBD2":
        return OpCode(v: code, c: "SET 2,D", m: " ", l: 1)
        case "CBD3":
        return OpCode(v: code, c: "SET 2,E", m: " ", l: 1)
        case "CBD4":
        return OpCode(v: code, c: "SET 2,H", m: " ", l: 1)
        case "CBD5":
        return OpCode(v: code, c: "SET 2,L", m: " ", l: 1)
        case "CBD6":
        return OpCode(v: code, c: "SET 2,(HL)", m: " ", l: 1)
        case "CBD7":
        return OpCode(v: code, c: "SET 2,A", m: " ", l: 1)
        case "CBD8":
        return OpCode(v: code, c: "SET 3,B", m: " ", l: 1)
        case "CBD9":
        return OpCode(v: code, c: "SET 3,C", m: " ", l: 1)
        case "CBDA":
        return OpCode(v: code, c: "SET 3,D", m: " ", l: 1)
        case "CBDB":
        return OpCode(v: code, c: "SET 3,E", m: " ", l: 1)
        case "CBDC":
        return OpCode(v: code, c: "SET 3,H", m: " ", l: 1)
        case "CBDD":
        return OpCode(v: code, c: "SET 3,L", m: " ", l: 1)
        case "CBDE":
        return OpCode(v: code, c: "SET 3,(HL)", m: " ", l: 1)
        case "CBDF":
        return OpCode(v: code, c: "SET 3,A", m: " ", l: 1)
        case "CBE0":
        return OpCode(v: code, c: "SET 4,B", m: " ", l: 1)
        case "CBE1":
        return OpCode(v: code, c: "SET 4,C", m: " ", l: 1)
        case "CBE2":
        return OpCode(v: code, c: "SET 4,D", m: " ", l: 1)
        case "CBE3":
        return OpCode(v: code, c: "SET 4,E", m: " ", l: 1)
        case "CBE4":
        return OpCode(v: code, c: "SET 4,H", m: " ", l: 1)
        case "CBE5":
        return OpCode(v: code, c: "SET 4,L", m: " ", l: 1)
        case "CBE6":
        return OpCode(v: code, c: "SET 4,(HL)", m: " ", l: 1)
        case "CBE7":
        return OpCode(v: code, c: "SET 4,A", m: " ", l: 1)
        case "CBE8":
        return OpCode(v: code, c: "SET 5,B", m: " ", l: 1)
        case "CBE9":
        return OpCode(v: code, c: "SET 5,C", m: " ", l: 1)
        case "CBEA":
        return OpCode(v: code, c: "SET 5,D", m: " ", l: 1)
        case "CBEB":
        return OpCode(v: code, c: "SET 5,E", m: " ", l: 1)
        case "CBEC":
        return OpCode(v: code, c: "SET 5,H", m: " ", l: 1)
        case "CBED":
        return OpCode(v: code, c: "SET 5,L", m: " ", l: 1)
        case "CBEE":
        return OpCode(v: code, c: "SET 5,(HL)", m: " ", l: 1)
        case "CBEF":
        return OpCode(v: code, c: "SET 5,A", m: " ", l: 1)
        case "CBF0":
        return OpCode(v: code, c: "SET 6,B", m: " ", l: 1)
        case "CBF1":
        return OpCode(v: code, c: "SET 6,C", m: " ", l: 1)
        case "CBF2":
        return OpCode(v: code, c: "SET 6,D", m: " ", l: 1)
        case "CBF3":
        return OpCode(v: code, c: "SET 6,E", m: " ", l: 1)
        case "CBF4":
        return OpCode(v: code, c: "SET 6,H", m: " ", l: 1)
        case "CBF5":
        return OpCode(v: code, c: "SET 6,L", m: " ", l: 1)
        case "CBF6":
        return OpCode(v: code, c: "SET 6,(HL)", m: " ", l: 1)
        case "CBF7":
        return OpCode(v: code, c: "SET 6,A", m: " ", l: 1)
        case "CBF8":
        return OpCode(v: code, c: "SET 7,B", m: " ", l: 1)
        case "CBF9":
        return OpCode(v: code, c: "SET 7,C", m: " ", l: 1)
        case "CBFA":
        return OpCode(v: code, c: "SET 7,D", m: " ", l: 1)
        case "CBFB":
        return OpCode(v: code, c: "SET 7,E", m: " ", l: 1)
        case "CBFC":
        return OpCode(v: code, c: "SET 7,H", m: " ", l: 1)
        case "CBFD":
        return OpCode(v: code, c: "SET 7,L", m: " ", l: 1)
        case "CBFE":
        return OpCode(v: code, c: "SET 7,(HL)", m: " ", l: 1)
        case "CBFF":
        return OpCode(v: code, c: "SET 7,A", m: " ", l: 1)
        case "FD00":
        return OpCode(v: code, c: "RLC (iy+0)->b", m: " ", l: 1)
        case "FD01":
        return OpCode(v: code, c: "RLC (iy+0)->c", m: " ", l: 1)
        case "FD02":
        return OpCode(v: code, c: "RLC (iy+0)->d", m: " ", l: 1)
        case "FD03":
        return OpCode(v: code, c: "RLC (iy+0)->e", m: " ", l: 1)
        case "FD04":
        return OpCode(v: code, c: "RLC (iy+0)->h", m: " ", l: 1)
        case "FD05":
        return OpCode(v: code, c: "RLC (iy+0)->l", m: " ", l: 1)
        case "FD06":
        return OpCode(v: code, c: "RLC (IY+0)", m: " ", l: 1)
        case "FD07":
        return OpCode(v: code, c: "RLC (iy+0)->a", m: " ", l: 1)
        case "FD08":
        return OpCode(v: code, c: "RRC (iy+0)->b", m: " ", l: 1)
        case "FD09":
        return OpCode(v: code, c: "RRC (iy+0)->c", m: " ", l: 1)
        case "FD0A":
        return OpCode(v: code, c: "RRC (iy+0)->d", m: " ", l: 1)
        case "FD0B":
        return OpCode(v: code, c: "RRC (iy+0)->e", m: " ", l: 1)
        case "FD0C":
        return OpCode(v: code, c: "RRC (iy+0)->h", m: " ", l: 1)
        case "FD0D":
        return OpCode(v: code, c: "RRC (iy+0)->l", m: " ", l: 1)
        case "FD0E":
        return OpCode(v: code, c: "RRC (IY+0)", m: " ", l: 1)
        case "FD0F":
        return OpCode(v: code, c: "RRC (iy+0)->a", m: " ", l: 1)
        case "FD10":
        return OpCode(v: code, c: "RL (iy+0)->b", m: " ", l: 1)
        case "FD11":
        return OpCode(v: code, c: "RL (iy+0)->c", m: " ", l: 1)
        case "FD12":
        return OpCode(v: code, c: "RL (iy+0)->d", m: " ", l: 1)
        case "FD13":
        return OpCode(v: code, c: "RL (iy+0)->e", m: " ", l: 1)
        case "FD14":
        return OpCode(v: code, c: "RL (iy+0)->h", m: " ", l: 1)
        case "FD15":
        return OpCode(v: code, c: "RL (iy+0)->l", m: " ", l: 1)
        case "FD16":
        return OpCode(v: code, c: "RL (IY+0)", m: " ", l: 1)
        case "FD17":
        return OpCode(v: code, c: "RL (iy+0)->a", m: " ", l: 1)
        case "FD18":
        return OpCode(v: code, c: "RR (iy+0)->b", m: " ", l: 1)
        case "FD19":
        return OpCode(v: code, c: "RR (iy+0)->c", m: " ", l: 1)
        case "FD1A":
        return OpCode(v: code, c: "RR (iy+0)->d", m: " ", l: 1)
        case "FD1B":
        return OpCode(v: code, c: "RR (iy+0)->e", m: " ", l: 1)
        case "FD1C":
        return OpCode(v: code, c: "RR (iy+0)->h", m: " ", l: 1)
        case "FD1D":
        return OpCode(v: code, c: "RR (iy+0)->l", m: " ", l: 1)
        case "FD1E":
        return OpCode(v: code, c: "RR (IY+0)", m: " ", l: 1)
        case "FD1F":
        return OpCode(v: code, c: "RR (iy+0)->a", m: " ", l: 1)
        case "FD20":
        return OpCode(v: code, c: "SLA (iy+0)->b", m: " ", l: 1)
        case "FD21":
        return OpCode(v: code, c: "SLA (iy+0)->c", m: " ", l: 1)
        case "FD22":
        return OpCode(v: code, c: "SLA (iy+0)->d", m: " ", l: 1)
        case "FD23":
        return OpCode(v: code, c: "SLA (iy+0)->e", m: " ", l: 1)
        case "FD24":
        return OpCode(v: code, c: "SLA (iy+0)->h", m: " ", l: 1)
        case "FD25":
        return OpCode(v: code, c: "SLA (iy+0)->l", m: " ", l: 1)
        case "FD26":
        return OpCode(v: code, c: "SLA (IY+0)", m: " ", l: 1)
        case "FD27":
        return OpCode(v: code, c: "SLA (iy+0)->a", m: " ", l: 1)
        case "FD28":
        return OpCode(v: code, c: "SRA (iy+0)->b", m: " ", l: 1)
        case "FD29":
        return OpCode(v: code, c: "SRA (iy+0)->c", m: " ", l: 1)
        case "FD2A":
        return OpCode(v: code, c: "SRA (iy+0)->d", m: " ", l: 1)
        case "FD2B":
        return OpCode(v: code, c: "SRA (iy+0)->e", m: " ", l: 1)
        case "FD2C":
        return OpCode(v: code, c: "SRA (iy+0)->h", m: " ", l: 1)
        case "FD2D":
        return OpCode(v: code, c: "SRA (iy+0)->l", m: " ", l: 1)
        case "FD2E":
        return OpCode(v: code, c: "SRA (IY+0)", m: " ", l: 1)
        case "FD2F":
        return OpCode(v: code, c: "SRA (iy+0)->a", m: " ", l: 1)
        case "FD30":
        return OpCode(v: code, c: "SLS (iy+0)->b", m: " ", l: 1)
        case "FD31":
        return OpCode(v: code, c: "SLS (iy+0)->c", m: " ", l: 1)
        case "FD32":
        return OpCode(v: code, c: "SLS (iy+0)->d", m: " ", l: 1)
        case "FD33":
        return OpCode(v: code, c: "SLS (iy+0)->e", m: " ", l: 1)
        case "FD34":
        return OpCode(v: code, c: "SLS (iy+0)->h", m: " ", l: 1)
        case "FD35":
        return OpCode(v: code, c: "SLS (iy+0)->l", m: " ", l: 1)
        case "FD36":
        return OpCode(v: code, c: "SLS (IY+0)", m: " ", l: 1)
        case "FD37":
        return OpCode(v: code, c: "SLS (iy+0)->a", m: " ", l: 1)
        case "FD38":
        return OpCode(v: code, c: "SRL (iy+0)->b", m: " ", l: 1)
        case "FD39":
        return OpCode(v: code, c: "SRL (iy+0)->c", m: " ", l: 1)
        case "FD3A":
        return OpCode(v: code, c: "SRL (iy+0)->d", m: " ", l: 1)
        case "FD3B":
        return OpCode(v: code, c: "SRL (iy+0)->e", m: " ", l: 1)
        case "FD3C":
        return OpCode(v: code, c: "SRL (iy+0)->h", m: " ", l: 1)
        case "FD3D":
        return OpCode(v: code, c: "SRL (iy+0)->l", m: " ", l: 1)
        case "FD3E":
        return OpCode(v: code, c: "SRL (IY+0)", m: " ", l: 1)
        case "FD3F":
        return OpCode(v: code, c: "SRL (iy+0)->a", m: " ", l: 1)
        case "FD40":
        return OpCode(v: code, c: "BIT 0,(iy+0)->b", m: " ", l: 1)
        case "FD41":
        return OpCode(v: code, c: "BIT 0,(iy+0)->c", m: " ", l: 1)
        case "FD42":
        return OpCode(v: code, c: "BIT 0,(iy+0)->d", m: " ", l: 1)
        case "FD43":
        return OpCode(v: code, c: "BIT 0,(iy+0)->e", m: " ", l: 1)
        case "FD44":
        return OpCode(v: code, c: "BIT 0,(iy+0)->h", m: " ", l: 1)
        case "FD45":
        return OpCode(v: code, c: "BIT 0,(iy+0)->l", m: " ", l: 1)
        case "FD46":
        return OpCode(v: code, c: "BIT 0,(IY+0)", m: " ", l: 1)
        case "FD47":
        return OpCode(v: code, c: "BIT 0,(iy+0)->a", m: " ", l: 1)
        case "FD48":
        return OpCode(v: code, c: "BIT 1,(iy+0)->b", m: " ", l: 1)
        case "FD49":
        return OpCode(v: code, c: "BIT 1,(iy+0)->c", m: " ", l: 1)
        case "FD4A":
        return OpCode(v: code, c: "BIT 1,(iy+0)->d", m: " ", l: 1)
        case "FD4B":
        return OpCode(v: code, c: "BIT 1,(iy+0)->e", m: " ", l: 1)
        case "FD4C":
        return OpCode(v: code, c: "BIT 1,(iy+0)->h", m: " ", l: 1)
        case "FD4D":
        return OpCode(v: code, c: "BIT 1,(iy+0)->l", m: " ", l: 1)
        case "FD4E":
        return OpCode(v: code, c: "BIT 1,(IY+0)", m: " ", l: 1)
        case "FD4F":
        return OpCode(v: code, c: "BIT 1,(iy+0)->a", m: " ", l: 1)
        case "FD50":
        return OpCode(v: code, c: "BIT 2,(iy+0)->b", m: " ", l: 1)
        case "FD51":
        return OpCode(v: code, c: "BIT 2,(iy+0)->c", m: " ", l: 1)
        case "FD52":
        return OpCode(v: code, c: "BIT 2,(iy+0)->d", m: " ", l: 1)
        case "FD53":
        return OpCode(v: code, c: "BIT 2,(iy+0)->e", m: " ", l: 1)
        case "FD54":
        return OpCode(v: code, c: "BIT 2,(iy+0)->h", m: " ", l: 1)
        case "FD55":
        return OpCode(v: code, c: "BIT 2,(iy+0)->l", m: " ", l: 1)
        case "FD56":
        return OpCode(v: code, c: "BIT 2,(IY+0)", m: " ", l: 1)
        case "FD57":
        return OpCode(v: code, c: "BIT 2,(iy+0)->a", m: " ", l: 1)
        case "FD58":
        return OpCode(v: code, c: "BIT 3,(iy+0)->b", m: " ", l: 1)
        case "FD59":
        return OpCode(v: code, c: "BIT 3,(iy+0)->c", m: " ", l: 1)
        case "FD5A":
        return OpCode(v: code, c: "BIT 3,(iy+0)->d", m: " ", l: 1)
        case "FD5B":
        return OpCode(v: code, c: "BIT 3,(iy+0)->e", m: " ", l: 1)
        case "FD5C":
        return OpCode(v: code, c: "BIT 3,(iy+0)->h", m: " ", l: 1)
        case "FD5D":
        return OpCode(v: code, c: "BIT 3,(iy+0)->l", m: " ", l: 1)
        case "FD5E":
        return OpCode(v: code, c: "BIT 3,(IY+0)", m: " ", l: 1)
        case "FD5F":
        return OpCode(v: code, c: "BIT 3,(iy+0)->a", m: " ", l: 1)
        case "FD60":
        return OpCode(v: code, c: "BIT 4,(iy+0)->b", m: " ", l: 1)
        case "FD61":
        return OpCode(v: code, c: "BIT 4,(iy+0)->c", m: " ", l: 1)
        case "FD62":
        return OpCode(v: code, c: "BIT 4,(iy+0)->d", m: " ", l: 1)
        case "FD63":
        return OpCode(v: code, c: "BIT 4,(iy+0)->e", m: " ", l: 1)
        case "FD64":
        return OpCode(v: code, c: "BIT 4,(iy+0)->h", m: " ", l: 1)
        case "FD65":
        return OpCode(v: code, c: "BIT 4,(iy+0)->l", m: " ", l: 1)
        case "FD66":
        return OpCode(v: code, c: "BIT 4,(IY+0)", m: " ", l: 1)
        case "FD67":
        return OpCode(v: code, c: "BIT 4,(iy+0)->a", m: " ", l: 1)
        case "FD68":
        return OpCode(v: code, c: "BIT 5,(iy+0)->b", m: " ", l: 1)
        case "FD69":
        return OpCode(v: code, c: "BIT 5,(iy+0)->c", m: " ", l: 1)
        case "FD6A":
        return OpCode(v: code, c: "BIT 5,(iy+0)->d", m: " ", l: 1)
        case "FD6B":
        return OpCode(v: code, c: "BIT 5,(iy+0)->e", m: " ", l: 1)
        case "FD6C":
        return OpCode(v: code, c: "BIT 5,(iy+0)->h", m: " ", l: 1)
        case "FD6D":
        return OpCode(v: code, c: "BIT 5,(iy+0)->l", m: " ", l: 1)
        case "FD6E":
        return OpCode(v: code, c: "BIT 5,(IY+0)", m: " ", l: 1)
        case "FD6F":
        return OpCode(v: code, c: "BIT  5,(iy+0)->a", m: " ", l: 1)
        case "FD70":
        return OpCode(v: code, c: "BIT 6,(iy+0)->b", m: " ", l: 1)
        case "FD71":
        return OpCode(v: code, c: "BIT 6,(iy+0)->c", m: " ", l: 1)
        case "FD72":
        return OpCode(v: code, c: "BIT 6,(iy+0)->d", m: " ", l: 1)
        case "FD73":
        return OpCode(v: code, c: "BIT 6,(iy+0)->e", m: " ", l: 1)
        case "FD74":
        return OpCode(v: code, c: "BIT 6,(iy+0)->h", m: " ", l: 1)
        case "FD75":
        return OpCode(v: code, c: "BIT 6,(iy+0)->l", m: " ", l: 1)
        case "FD76":
        return OpCode(v: code, c: "BIT 6,(IY+0)", m: " ", l: 1)
        case "FD77":
        return OpCode(v: code, c: "BIT 6,(iy+0)->a", m: " ", l: 1)
        case "FD78":
        return OpCode(v: code, c: "BIT 7,(iy+0)->b", m: " ", l: 1)
        case "FD79":
        return OpCode(v: code, c: "BIT 7,(iy+0)->c", m: " ", l: 1)
        case "FD7A":
        return OpCode(v: code, c: "BIT 7,(iy+0)->d", m: " ", l: 1)
        case "FD7B":
        return OpCode(v: code, c: "BIT 7,(iy+0)->e", m: " ", l: 1)
        case "FD7C":
        return OpCode(v: code, c: "BIT 7,(iy+0)->h", m: " ", l: 1)
        case "FD7D":
        return OpCode(v: code, c: "BIT 7,(iy+0)->l", m: " ", l: 1)
        case "FD7E":
        return OpCode(v: code, c: "BIT 7,(IY+0)", m: " ", l: 1)
        case "FD7F":
        return OpCode(v: code, c: "BIT 7,(iy+0)->a", m: " ", l: 1)
        case "FD80":
        return OpCode(v: code, c: "RES 0,(iy+0)->b", m: " ", l: 1)
        case "FD81":
        return OpCode(v: code, c: "RES 0,(iy+0)->c", m: " ", l: 1)
        case "FD82":
        return OpCode(v: code, c: "RES 0,(iy+0)->d", m: " ", l: 1)
        case "FD83":
        return OpCode(v: code, c: "RES 0,(iy+0)->e", m: " ", l: 1)
        case "FD84":
        return OpCode(v: code, c: "RES 0,(iy+0)->h", m: " ", l: 1)
        case "FD85":
        return OpCode(v: code, c: "RES 0,(iy+0)->l", m: " ", l: 1)
        case "FD86":
        return OpCode(v: code, c: "RES 0,(IY+0)", m: " ", l: 1)
        case "FD87":
        return OpCode(v: code, c: "RES 0,(iy+0)->a", m: " ", l: 1)
        case "FD88":
        return OpCode(v: code, c: "RES 1,(iy+0)->b", m: " ", l: 1)
        case "FD89":
        return OpCode(v: code, c: "RES 1,(iy+0)->c", m: " ", l: 1)
        case "FD8A":
        return OpCode(v: code, c: "RES 1,(iy+0)->d", m: " ", l: 1)
        case "FD8B":
        return OpCode(v: code, c: "RES 1,(iy+0)->e", m: " ", l: 1)
        case "FD8C":
        return OpCode(v: code, c: "RES 1,(iy+0)->h", m: " ", l: 1)
        case "FD8D":
        return OpCode(v: code, c: "RES 1,(iy+0)->l", m: " ", l: 1)
        case "FD8E":
        return OpCode(v: code, c: "RES 1,(IY+0)", m: " ", l: 1)
        case "FD8F":
        return OpCode(v: code, c: "RES 1,(iy+0)->a", m: " ", l: 1)
        case "FD90":
        return OpCode(v: code, c: "RES 2,(iy+0)->b", m: " ", l: 1)
        case "FD91":
        return OpCode(v: code, c: "RES 2,(iy+0)->c", m: " ", l: 1)
        case "FD92":
        return OpCode(v: code, c: "RES 2,(iy+0)->d", m: " ", l: 1)
        case "FD93":
        return OpCode(v: code, c: "RES 2,(iy+0)->e", m: " ", l: 1)
        case "FD94":
        return OpCode(v: code, c: "RES 2,(iy+0)->h", m: " ", l: 1)
        case "FD95":
        return OpCode(v: code, c: "RES 2,(iy+0)->l", m: " ", l: 1)
        case "FD96":
        return OpCode(v: code, c: "RES 2,(IY+0)", m: " ", l: 1)
        case "FD97":
        return OpCode(v: code, c: "RES 2,(iy+0)->a", m: " ", l: 1)
        case "FD98":
        return OpCode(v: code, c: "RES 3,(iy+0)->b", m: " ", l: 1)
        case "FD99":
        return OpCode(v: code, c: "RES 3,(iy+0)->c", m: " ", l: 1)
        case "FD9A":
        return OpCode(v: code, c: "RES 3,(iy+0)->d", m: " ", l: 1)
        case "FD9B":
        return OpCode(v: code, c: "RES 3,(iy+0)->e", m: " ", l: 1)
        case "FD9C":
        return OpCode(v: code, c: "RES 3,(iy+0)->h", m: " ", l: 1)
        case "FD9D":
        return OpCode(v: code, c: "RES 3,(iy+0)->l", m: " ", l: 1)
        case "FD9E":
        return OpCode(v: code, c: "RES 3,(IY+0)", m: " ", l: 1)
        case "FD9F":
        return OpCode(v: code, c: "RES 3,(iy+0)->a", m: " ", l: 1)
        case "FDA0":
        return OpCode(v: code, c: "RES 4,(iy+0)->b", m: " ", l: 1)
        case "FDA1":
        return OpCode(v: code, c: "RES 4,(iy+0)->c", m: " ", l: 1)
        case "FDA2":
        return OpCode(v: code, c: "RES 4,(iy+0)->d", m: " ", l: 1)
        case "FDA3":
        return OpCode(v: code, c: "RES 4,(iy+0)->e", m: " ", l: 1)
        case "FDA4":
        return OpCode(v: code, c: "RES 4,(iy+0)->h", m: " ", l: 1)
        case "FDA5":
        return OpCode(v: code, c: "RES 4,(iy+0)->l", m: " ", l: 1)
        case "FDA6":
        return OpCode(v: code, c: "RES 4,(IY+0)", m: " ", l: 1)
        case "FDA7":
        return OpCode(v: code, c: "RES 4,(iy+0)->a", m: " ", l: 1)
        case "FDA8":
        return OpCode(v: code, c: "RES 5,(iy+0)->b", m: " ", l: 1)
        case "FDA9":
        return OpCode(v: code, c: "RES 5,(iy+0)->c", m: " ", l: 1)
        case "FDAA":
        return OpCode(v: code, c: "RES 5,(iy+0)->d", m: " ", l: 1)
        case "FDAB":
        return OpCode(v: code, c: "RES 5,(iy+0)->e", m: " ", l: 1)
        case "FDAC":
        return OpCode(v: code, c: "RES 5,(iy+0)->h", m: " ", l: 1)
        case "FDAD":
        return OpCode(v: code, c: "RES 5,(iy+0)->l", m: " ", l: 1)
        case "FDAE":
        return OpCode(v: code, c: "RES 5,(IY+0)", m: " ", l: 1)
        case "FDAF":
        return OpCode(v: code, c: "RES 5,(iy+0)->a", m: " ", l: 1)
        case "FDB0":
        return OpCode(v: code, c: "RES 6,(iy+0)->b", m: " ", l: 1)
        case "FDB1":
        return OpCode(v: code, c: "RES 6,(iy+0)->c", m: " ", l: 1)
        case "FDB2":
        return OpCode(v: code, c: "RES 6,(iy+0)->d", m: " ", l: 1)
        case "FDB3":
        return OpCode(v: code, c: "RES 6,(iy+0)->e", m: " ", l: 1)
        case "FDB4":
        return OpCode(v: code, c: "RES 6,(iy+0)->h", m: " ", l: 1)
        case "FDB5":
        return OpCode(v: code, c: "RES 6,(iy+0)->l", m: " ", l: 1)
        case "FDB6":
        return OpCode(v: code, c: "RES 6,(IY+0)", m: " ", l: 1)
        case "FDB7":
        return OpCode(v: code, c: "RES 6,(iy+0)->a", m: " ", l: 1)
        case "FDB8":
        return OpCode(v: code, c: "RES 7,(iy+0)->b", m: " ", l: 1)
        case "FDB9":
        return OpCode(v: code, c: "RES 7,(iy+0)->c", m: " ", l: 1)
        case "FDBA":
        return OpCode(v: code, c: "RES 7,(iy+0)->d", m: " ", l: 1)
        case "FDBB":
        return OpCode(v: code, c: "RES 7,(iy+0)->e", m: " ", l: 1)
        case "FDBC":
        return OpCode(v: code, c: "RES 7,(iy+0)->h", m: " ", l: 1)
        case "FDBD":
        return OpCode(v: code, c: "RES 7,(iy+0)->l", m: " ", l: 1)
        case "FDBE":
        return OpCode(v: code, c: "RES 7,(IY+0)", m: " ", l: 1)
        case "FDBF":
        return OpCode(v: code, c: "RES 7,(iy+0)->a", m: " ", l: 1)
        case "FDC0":
        return OpCode(v: code, c: "SET 0,(iy+0)->b", m: " ", l: 1)
        case "FDC1":
        return OpCode(v: code, c: "SET 0,(iy+0)->c", m: " ", l: 1)
        case "FDC2":
        return OpCode(v: code, c: "SET 0,(iy+0)->d", m: " ", l: 1)
        case "FDC3":
        return OpCode(v: code, c: "SET 0,(iy+0)->e", m: " ", l: 1)
        case "FDC4":
        return OpCode(v: code, c: "SET 0,(iy+0)->h", m: " ", l: 1)
        case "FDC5":
        return OpCode(v: code, c: "SET 0,(iy+0)->l", m: " ", l: 1)
        case "FDC6":
        return OpCode(v: code, c: "SET 0,(IY+0)", m: " ", l: 1)
        case "FDC7":
        return OpCode(v: code, c: "SET 0,(iy+0)->a", m: " ", l: 1)
        case "FDC8":
        return OpCode(v: code, c: "SET 1,(iy+0)->b", m: " ", l: 1)
        case "FDC9":
        return OpCode(v: code, c: "SET 1,(iy+0)->c", m: " ", l: 1)
        case "FDCA":
        return OpCode(v: code, c: "SET 1,(iy+0)->d", m: " ", l: 1)
        case "FDCB":
        return OpCode(v: code, c: "SET 1,(iy+0)->e", m: " ", l: 1)
        case "FDCC":
        return OpCode(v: code, c: "SET 1,(iy+0)->h", m: " ", l: 1)
        case "FDCD":
        return OpCode(v: code, c: "SET 1,(iy+0)->l", m: " ", l: 1)
        case "FDCE":
        return OpCode(v: code, c: "SET 1,(IY+0)", m: " ", l: 1)
        case "FDCF":
        return OpCode(v: code, c: "SET 1,(iy+0)->a", m: " ", l: 1)
        case "FDD0":
        return OpCode(v: code, c: "SET 2,(iy+0)->b", m: " ", l: 1)
        case "FDD1":
        return OpCode(v: code, c: "SET 2,(iy+0)->c", m: " ", l: 1)
        case "FDD2":
        return OpCode(v: code, c: "SET 2,(iy+0)->d", m: " ", l: 1)
        case "FDD3":
        return OpCode(v: code, c: "SET 2,(iy+0)->e", m: " ", l: 1)
        case "FDD4":
        return OpCode(v: code, c: "SET 2,(iy+0)->h", m: " ", l: 1)
        case "FDD5":
        return OpCode(v: code, c: "SET 2,(iy+0)->l", m: " ", l: 1)
        case "FDD6":
        return OpCode(v: code, c: "SET 2,(IY+0)", m: " ", l: 1)
        case "FDD7":
        return OpCode(v: code, c: "SET 2,(iy+0)->a", m: " ", l: 1)
        case "FDD8":
        return OpCode(v: code, c: "SET 3,(iy+0)->b", m: " ", l: 1)
        case "FDD9":
        return OpCode(v: code, c: "SET 3,(iy+0)->c", m: " ", l: 1)
        case "FDDA":
        return OpCode(v: code, c: "SET 3,(iy+0)->d", m: " ", l: 1)
        case "FDDB":
        return OpCode(v: code, c: "SET 3,(iy+0)->e", m: " ", l: 1)
        case "FDDC":
        return OpCode(v: code, c: "SET 3,(iy+0)->h", m: " ", l: 1)
        case "FDDD":
        return OpCode(v: code, c: "SET 3,(iy+0)->l", m: " ", l: 1)
        case "FDDE":
        return OpCode(v: code, c: "SET 3,(IY+0)", m: " ", l: 1)
        case "FDDF":
        return OpCode(v: code, c: "SET 3,(iy+0)->a", m: " ", l: 1)
        case "FDE0":
        return OpCode(v: code, c: "SET 4,(iy+0)->b", m: " ", l: 1)
        case "FDE1":
        return OpCode(v: code, c: "SET 4,(iy+0)->c", m: " ", l: 1)
        case "FDE2":
        return OpCode(v: code, c: "SET 4,(iy+0)->d", m: " ", l: 1)
        case "FDE3":
        return OpCode(v: code, c: "SET 4,(iy+0)->e", m: " ", l: 1)
        case "FDE4":
        return OpCode(v: code, c: "SET 4,(iy+0)->h", m: " ", l: 1)
        case "FDE5":
        return OpCode(v: code, c: "SET 4,(iy+0)->l", m: " ", l: 1)
        case "FDE6":
        return OpCode(v: code, c: "SET 4,(IY+0)", m: " ", l: 1)
        case "FDE7":
        return OpCode(v: code, c: "SET 4,(iy+0)->a", m: " ", l: 1)
        case "FDE8":
        return OpCode(v: code, c: "SET 5,(iy+0)->b", m: " ", l: 1)
        case "FDE9":
        return OpCode(v: code, c: "SET 5,(iy+0)->c", m: " ", l: 1)
        case "FDEA":
        return OpCode(v: code, c: "SET 5,(iy+0)->d", m: " ", l: 1)
        case "FDEB":
        return OpCode(v: code, c: "SET 5,(iy+0)->e", m: " ", l: 1)
        case "FDEC":
        return OpCode(v: code, c: "SET 5,(iy+0)->h", m: " ", l: 1)
        case "FDED":
        return OpCode(v: code, c: "SET 5,(iy+0)->l", m: " ", l: 1)
        case "FDEE":
        return OpCode(v: code, c: "SET 5,(IY+0)", m: " ", l: 1)
        case "FDEF":
        return OpCode(v: code, c: "SET 5,(iy+0)->a", m: " ", l: 1)
        case "FDF0":
        return OpCode(v: code, c: "SET 6,(iy+0)->b", m: " ", l: 1)
        case "FDF1":
        return OpCode(v: code, c: "SET 6,(iy+0)->c", m: " ", l: 1)
        case "FDF2":
        return OpCode(v: code, c: "SET 6,(iy+0)->d", m: " ", l: 1)
        case "FDF3":
        return OpCode(v: code, c: "SET 6,(iy+0)->e", m: " ", l: 1)
        case "FDF4":
        return OpCode(v: code, c: "SET 6,(iy+0)->h", m: " ", l: 1)
        case "FDF5":
        return OpCode(v: code, c: "SET 6,(iy+0)->l", m: " ", l: 1)
        case "FDF6":
        return OpCode(v: code, c: "SET 6,(IY+0)", m: " ", l: 1)
        case "FDF7":
        return OpCode(v: code, c: "SET 6,(iy+0)->a", m: " ", l: 1)
        case "FDF8":
        return OpCode(v: code, c: "SET 7,(iy+0)->b", m: " ", l: 1)
        case "FDF9":
        return OpCode(v: code, c: "SET 7,(iy+0)->c", m: " ", l: 1)
        case "FDFA":
        return OpCode(v: code, c: "SET 7,(iy+0)->d", m: " ", l: 1)
        case "FDFB":
        return OpCode(v: code, c: "SET 7,(iy+0)->e", m: " ", l: 1)
        case "FDFC":
        return OpCode(v: code, c: "SET 7,(iy+0)->h", m: " ", l: 1)
        case "FDFD":
        return OpCode(v: code, c: "SET 7,(iy+0)->l", m: " ", l: 1)
        case "FDFE":
        return OpCode(v: code, c: "SET 7,(IY+0)", m: " ", l: 1)
        case "FDFF":
        return OpCode(v: code, c: "SET 7,(iy+0)->a", m: " ", l: 1)
        case "ED00":
        return OpCode(v: code, c: "MOS_QUIT", m: " ", l: 1)
        case "ED01":
        return OpCode(v: code, c: "MOS_CLI", m: " ", l: 1)
        case "ED02":
        return OpCode(v: code, c: "MOS_BYTE", m: " ", l: 1)
        case "ED03":
        return OpCode(v: code, c: "MOS_WORD", m: " ", l: 1)
        case "ED04":
        return OpCode(v: code, c: "MOS_WRCH", m: " ", l: 1)
        case "ED05":
        return OpCode(v: code, c: "MOS_RDCH", m: " ", l: 1)
        case "ED06":
        return OpCode(v: code, c: "MOS_FILE", m: " ", l: 1)
        case "ED07":
        return OpCode(v: code, c: "MOS_ARGS", m: " ", l: 1)
        case "ED08":
        return OpCode(v: code, c: "MOS_BGET", m: " ", l: 1)
        case "ED09":
        return OpCode(v: code, c: "MOS_BPUT", m: " ", l: 1)
        case "ED0A":
        return OpCode(v: code, c: "MOS_GBPB", m: " ", l: 1)
        case "ED0B":
        return OpCode(v: code, c: "MOS_FIND", m: " ", l: 1)
        case "ED0C":
        return OpCode(v: code, c: "MOS_FF0C", m: " ", l: 1)
        case "ED0D":
        return OpCode(v: code, c: "MOS_FF0D", m: " ", l: 1)
        case "ED0E":
        return OpCode(v: code, c: "MOS_FF0E", m: " ", l: 1)
        case "ED0F":
        return OpCode(v: code, c: "MOS_FF0F", m: " ", l: 1)
        case "ED40":
        return OpCode(v: code, c: "IN B,(C)", m: " ", l: 1)
        case "ED41":
        return OpCode(v: code, c: "OUT (C),B", m: " ", l: 1)
        case "ED42":
        return OpCode(v: code, c: "SBC HL,BC", m: " ", l: 1)
        case "ED43":
        return OpCode(v: code, c: "LD ($$),BC", m: " ", l: 3, t: .DATA)
        case "ED44":
        return OpCode(v: code, c: "NEG", m: " ", l: 1)
        case "ED45":
        return OpCode(v: code, c: "RET N", m: " ", l: 1)
        case "ED46":
        return OpCode(v: code, c: "IM0", m: " ", l: 1)
        case "ED47":
        return OpCode(v: code, c: "LD I,A", m: " ", l: 1)
        case "ED48":
        return OpCode(v: code, c: "INC ,(C)", m: " ", l: 1)
        case "ED49":
        return OpCode(v: code, c: "OUT (C),C", m: " ", l: 1)
        case "ED4A":
        return OpCode(v: code, c: "ADC HL,BC", m: " ", l: 1)
        case "ED4B":
        return OpCode(v: code, c: "LD BC,($$)", m: " ", l: 3, t: .DATA)
        case "ED4C":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED4D":
        return OpCode(v: code, c: "RET I", m: " ", l: 1)
        case "ED4E":
        return OpCode(v: code, c: "[im0]", m: " ", l: 1)
        case "ED4F":
        return OpCode(v: code, c: "LD R,A", m: " ", l: 1)
        case "ED50":
        return OpCode(v: code, c: "IN D,(C)", m: " ", l: 1)
        case "ED51":
        return OpCode(v: code, c: "OUT (C),D", m: " ", l: 1)
        case "ED52":
        return OpCode(v: code, c: "SBC HL,DE", m: " ", l: 1)
        case "ED53":
        return OpCode(v: code, c: "LD ($$),DE", m: " ", l: 3, t: .DATA)
        case "ED54":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED55":
        return OpCode(v: code, c: "[retn]", m: " ", l: 1)
        case "ED56":
        return OpCode(v: code, c: "IM1", m: " ", l: 1)
        case "ED57":
        return OpCode(v: code, c: "LD A,I", m: " ", l: 1)
        case "ED58":
        return OpCode(v: code, c: "IN E,(C)", m: " ", l: 1)
        case "ED59":
        return OpCode(v: code, c: "OUT (C),E", m: " ", l: 1)
        case "ED5A":
        return OpCode(v: code, c: "ADC HL,DE", m: " ", l: 1)
        case "ED5B":
        return OpCode(v: code, c: "LD DE,($$)", m: " ", l: 3, t: .DATA)
        case "ED5C":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED5D":
        return OpCode(v: code, c: "[reti]", m: " ", l: 1)
        case "ED5E":
        return OpCode(v: code, c: "IM2", m: " ", l: 1)
        case "ED5F":
        return OpCode(v: code, c: "LD A,R", m: " ", l: 1)
        case "ED60":
        return OpCode(v: code, c: "IN H,(C)", m: " ", l: 1)
        case "ED61":
        return OpCode(v: code, c: "OUT (C),H", m: " ", l: 1)
        case "ED62":
        return OpCode(v: code, c: "SBC HL,HL", m: " ", l: 1)
        case "ED63":
        return OpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
        case "ED64":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED65":
        return OpCode(v: code, c: "[retn]", m: " ", l: 1)
        case "ED66":
        return OpCode(v: code, c: "[im0]", m: " ", l: 1)
        case "ED67":
        return OpCode(v: code, c: "RRD", m: " ", l: 1)
        case "ED68":
        return OpCode(v: code, c: "IN L,(C)", m: " ", l: 1)
        case "ED69":
        return OpCode(v: code, c: "OUT (C),L", m: " ", l: 1)
        case "ED6A":
        return OpCode(v: code, c: "ADC HL,HL", m: " ", l: 1)
        case "ED6B":
        return OpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
        case "ED6C":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED6D":
        return OpCode(v: code, c: "[reti]", m: " ", l: 1)
        case "ED6E":
        return OpCode(v: code, c: "[im0]", m: " ", l: 1)
        case "ED6F":
        return OpCode(v: code, c: "BIT 5,(iy+0)->a", m: " ", l: 1)
        case "ED70":
        return OpCode(v: code, c: "IN F,(C)", m: " ", l: 1)
        case "ED71":
        return OpCode(v: code, c: "OUT (C),F", m: " ", l: 1)
        case "ED72":
        return OpCode(v: code, c: "SBC HL,SP", m: " ", l: 1)
        case "ED73":
        return OpCode(v: code, c: "LD ($$),SP", m: " ", l: 3, t: .DATA)
        case "ED74":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED75":
        return OpCode(v: code, c: "[retn]", m: " ", l: 1)
        case "ED76":
        return OpCode(v: code, c: "[im1]", m: " ", l: 1)
        case "ED77":
        return OpCode(v: code, c: "[ldi,i?]", m: " ", l: 1)
        case "ED78":
        return OpCode(v: code, c: "IN A,(C)", m: " ", l: 1)
        case "ED79":
        return OpCode(v: code, c: "OUT (C),A", m: " ", l: 1)
        case "ED7A":
        return OpCode(v: code, c: "ADC HL,SP", m: " ", l: 1)
        case "ED7B":
        return OpCode(v: code, c: "LD SP,($$)", m: " ", l: 3)
        case "ED7C":
        return OpCode(v: code, c: "[neg]", m: " ", l: 1)
        case "ED7D":
        return OpCode(v: code, c: "[reti]", m: " ", l: 1)
        case "ED7E":
        return OpCode(v: code, c: "[im2]", m: " ", l: 1)
        case "ED7F":
        return OpCode(v: code, c: "[ldr,r?]", m: " ", l: 1)
        case "EDA0":
        return OpCode(v: code, c: "LD I", m: " ", l: 1)
        case "EDA1":
        return OpCode(v: code, c: "CP I", m: " ", l: 1)
        case "EDA2":
        return OpCode(v: code, c: "IN I", m: " ", l: 1)
        case "EDA3":
        return OpCode(v: code, c: "OTI", m: " ", l: 1)
        case "EDA8":
        return OpCode(v: code, c: "LD D", m: " ", l: 1)
        case "EDA9":
        return OpCode(v: code, c: "CP D", m: " ", l: 1)
        case "EDAA":
        return OpCode(v: code, c: "IN D", m: " ", l: 1)
        case "EDAB":
        return OpCode(v: code, c: "OTD", m: " ", l: 1)
        case "EDB0":
        return OpCode(v: code, c: "LD IR", m: " ", l: 1)
        case "EDB1":
        return OpCode(v: code, c: "CP IR", m: " ", l: 1)
        case "EDB2":
        return OpCode(v: code, c: "IN IR", m: " ", l: 1)
        case "EDB3":
        return OpCode(v: code, c: "OTIR", m: " ", l: 1)
        case "EDB8":
        return OpCode(v: code, c: "LD DR", m: " ", l: 1)
        case "EDB9":
        return OpCode(v: code, c: "CP DR", m: " ", l: 1)
        case "EDBA":
        return OpCode(v: code, c: "IN DR", m: " ", l: 1)
        case "EDBB":
        return OpCode(v: code, c: "OTDR", m: " ", l: 1)
        case "EDF8":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDF9":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDFA":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDFB":
        return OpCode(v: code, c: "ED_LOAD", m: " ", l: 1)
        case "EDFC":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDFD":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDFE":
        return OpCode(v: code, c: "[z80]", m: " ", l: 1)
        case "EDFF":
        return OpCode(v: code, c: "ED_DOS", m: " ", l: 1)
            
            
        default:
            return OpCode(v: code, c: "Unknown", m: "Value is not known", l: -1, e: true)

        }
        
    }
    
    
}
