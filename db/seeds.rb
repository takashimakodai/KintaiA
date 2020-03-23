# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "上長A",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true)

User.create!(name: "上長B",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password",
             superior: true)

User.create!(name: "一般A",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password")

User.create!(name: "一般B",
             email: "sample-4@email.com",
             password: "password",
             password_confirmation: "password")




