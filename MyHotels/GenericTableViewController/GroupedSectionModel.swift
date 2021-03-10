//  GroupedSectionModel.swift
//  MyHotels
//  Created by radha chilamkurthy on 07/03/21.

struct GroupedModel {
    var section: Int
    var rows: Int
    var customCell: RegisterModelType? = nil
    var header: RegisterModelType? = nil
    var footer: RegisterModelType? = nil
    
    init(section : Int, rows: Int, customCell: RegisterModelType? = nil, header: RegisterModelType? = nil, footer: RegisterModelType? = nil) {
        self.section = section
        self.rows = rows
        self.customCell = customCell
        self.header = header
        self.footer = footer
    }
}
