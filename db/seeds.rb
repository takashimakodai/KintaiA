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
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0), 
             superior: true)

User.create!(name: "上長B",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0),
             superior: true)

User.create!(name: "一般A",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password")

User.create!(name: "一般B",
             email: "sample-4@email.com",
             password: "password",
             password_confirmation: "password")

Base.create!(base_number: "1",
             base_name: "東京",
             base_category: "新宿",
             user_id: "1")
             
Base.create!(base_number: "2",
             base_name: "沖縄",
             base_category: "那覇",
             user_id: "1")




