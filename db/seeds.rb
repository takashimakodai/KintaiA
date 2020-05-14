# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             uid: "111",
             admin: true)

User.create!(name: "上長A",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0),
             uid: "222",
             superior: true)

User.create!(name: "上長B",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0),
             uid: "333",
             superior: true)

User.create!(name: "一般X",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0),
             uid: "444")

User.create!(name: "一般Y",
             email: "sample-4@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: Time.current.change(hour: 9, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 17, min: 0, sec: 0),
             uid: "555")




