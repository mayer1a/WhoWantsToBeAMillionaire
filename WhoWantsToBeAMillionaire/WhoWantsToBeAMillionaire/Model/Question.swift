//
//  Question.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 03.12.2022.
//

import Foundation

/// An object that stores data about question
struct Question {

    // MARK: - Properties

    let text: String
    let answers: [String : Int]
    let correctAnswer: String
    let callFriendHint: String = """
        При выборе подсказки «Звонок другу» случайно будет выбран один из трёх вариантов развития событий представленных ниже.
            1. «Друг» полностью не знает ответ на вопрос и выдаст предположение из двух вариантов ответа. Оно может быть полностью ложно, а может указать на правильный ответ;
            2. «Друг» сомневается в выборе и выдаст предположение из двух вариантов, один из которых точно верный;
            3. «Друг» полностью уверен в своём ответе и выдаст предположение из одного верного варианта.
        """

    let fiftyTofiftyHint: String = """
        «50 на 50» — компьютер убирает два неправильных ответа, предоставляя игроку выбор из оставшихся двух вариантов ответа.
        """
    
    let auditoryHelpHint: String = """
        При выборе подсказки «Помощь зала» у всех ответов появится процентное значение проголосовавших людей за каждый ответ
        Необязательно, что бОльшее количество процентов означает верный ответ. Люди из зала тоже могут ошибаться
        """
}

extension Question {

    // MARK: - Functions

    /// Get a list of hardcore level questions for the game
    /// - Returns: a collection of prepared questions
    public static func hardcoreQuestions() -> [Question] {

        let questions = [
            Question(text: "Кто был первым военным министром Российской империи?",
                     answers: ["Аракчеев": 42, "Барклай-де-Толли": 20, "Вязмитинов": 25, "Коновницын": 10],
                     correctAnswer: "Вязмитинов"),
            Question(text: "Реки с каким названием нет на территории России?",
                     answers: ["Спина": 51, "Уста": 8, "Палец": 26, "Шея": 13],
                     correctAnswer: "Спина"),
            Question(text: "Что Шекспир назвал «вкуснейшим из блюд в земном пиру»?",
                     answers: ["Опьянение": 7, "Любовь": 39, "Уединение": 8, "Сон": 45],
                     correctAnswer: "Сон"),
            Question(text: "Кто из этих философов в 1864 году написал музыку на стихи А. С. Пушкина «Заклинание» и «Зимний вечер»?",
                     answers: ["Юнг": 17, "Ницше": 30, "Шопенгауэр": 37, "Гегель": 14],
                     correctAnswer: "Ницше"),
            Question(text: "С какой фигуры начинаются соревнования по городошному спорту?",
                     answers: ["Часовые": 23, "Артиллерия": 6, "Пушка": 54, "Пулемётное гнездо": 14],
                     correctAnswer: "Пушка"),
            Question(text: "Сколько раз в сутки подзаводят куранты Спасской башни Кремля?",
                     answers: ["Один": 45, "Два": 40, "Три": 5, "Четыре": 8],
                     correctAnswer: "Два"),
            Question(text: "Как назвали первую кимберлитовую трубку, открытую Ларисой Попугаевой 21 августа 1954 года?",
                     answers: ["«Советская»": 19, "«Зарница»": 32, "«Удачная»": 14, "«Мир»": 33],
                     correctAnswer: "«Зарница»"),
            Question(text: "Что Иван Ефремов в романе «Лезвие бритвы» назвал наивысшей степенью целесообразности?",
                     answers: ["Красоту": 17, "Мудрость": 22, "Смерть": 29, "Свободу": 31],
                     correctAnswer: "Красоту"),
            Question(text: "В какой из этих столиц бывших союзных республик раньше появилось метро?",
                     answers: ["Ереван": 8, "Тбилиси": 30, "Баку": 18, "Минск": 42],
                     correctAnswer: "Тбилиси"),
            Question(text: "Сколько морей омывают Балканский полуостров?",
                     answers: ["3": 37, "4": 27, "5": 16, "6": 18],
                     correctAnswer: "6")
        ]

        return questions
    }

    /// Get a list of easy level questions for the game
    /// - Returns: a collection of prepared questions
    public static func easyQuestions() -> [Question] {

        let questions = [
            Question(text: "Как называют манекенщицу супер-класса?",
                     answers: ["Топ-модель": 42, "Тяп-модель": 20, "Поп-модель": 25, "Ляп-модель": 10],
                     correctAnswer: "Топ-модель"),
            Question(text: "Кто вырос в джунглях среди диких зверей?",
                     answers: ["Колобок": 51, "Маугли": 8, "Бэтмен": 26, "Чарльз Дарвин": 13],
                     correctAnswer: "Маугли"),
            Question(text: "Как называлась детская развлекательная программа, популярная в прошлые годы?",
                     answers: ["АБВГДейка": 7, "ЁКЛМНейка": 39, "ЁПРСТейка": 8, "ЁЖЗИКейка": 45],
                     correctAnswer: "АБВГДейка"),
            Question(text: "Как звали невесту Эдмона Дантеса, будущего графа Монте-Кристо?",
                     answers: ["Мерседес": 17, "Тойота": 30, "Хонда": 37, "Лада": 14],
                     correctAnswer: "Мерседес"),
            Question(text: "Какой цвет получается при смешении синего и красного?",
                     answers: ["Коричневый": 23, "Фиолетовый": 6, "Зелёный": 54, "Голубой": 14],
                     correctAnswer: "Фиолетовый"),
            Question(text: "Из какого мяса традиционно готовится начинка для чебуреков?",
                     answers: ["Баранина": 45, "Свинина": 40, "Телятина": 5, "Конина": 8],
                     correctAnswer: "Баранина"),
            Question(text: "Какой народ придумал танец чардаш?",
                     answers: ["Венгры": 19, "Румыны": 32, "Чехи": 14, "Молдаване": 33],
                     correctAnswer: "Венгры"),
            Question(text: "Изучение соединений какого элемента является основой органической химии?",
                     answers: ["Кислород": 17, "Углерод": 22, "Азот": 29, "Кремний": 31],
                     correctAnswer: "Углерод"),
            Question(text: "Кто открыл тайну трёх карт графине из «Пиковой дамы» А. С. Пушкина?",
                     answers: ["Казанова": 8, "Калиостро": 30, "Сен-Жермен": 18, "Томас Воган": 42],
                     correctAnswer: "Сен-Жермен"),
            Question(text: "В какой стране была пробурена первая промышленная нефтяная скважина?",
                     answers: ["Кувейт": 37, "Иран": 27, "Ирак": 16, "Азербайджан": 18],
                     correctAnswer: "Азербайджан")
        ]

        return questions
    }
}