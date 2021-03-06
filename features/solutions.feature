# language: bg
Функционалност: Решения
  За да могат студентите да учат един от друг
  като преподаватели
  искаме да могат да разглеждат решенията си и да обменят идеи върху тях чрез коментари

  Сценарий: Разглеждане на решения
    Дадено че "Първа задача" има следните решения:
      | Студент      | Успешни | Неуспешни | Код             |
      | Петър Петров | 12      | 6         | print("larodi") |
      | Иван Иванов  | 18      | 0         | print("baba")   |
    Когато отида на решенията на "Първа задача"
    То трябва да виждам следните решения:
      | Име          | Изпълнение                                                         |
      | Петър Петров | Успешни тестове: 12, Неуспешни тестове: 6, Редове: 1, Коментари: 0 |
      | Иван Иванов  | Успешни тестове: 18, Неуспешни тестове: 0, Редове: 1, Коментари: 0 |

  Рамка на сценарий: Изчисляване на точки за решение
    Дадено че "Първа задача" има следните решения:
      | Студент      | Успешни   | Неуспешни   | Код             |
      | Петър Петров | <Успешни> | <Неуспешни> | print("larodi") |
    Когато отида на решенията на "Първа задача"
    То трябва да виждам едно решение с "<Точки>" точки

    Примери:
      | Успешни | Неуспешни | Точки |
      | 18      | 0         | 6     |
      | 17      | 1         | 6     |
      | 16      | 2         | 5     |
      | 12      | 6         | 4     |
      | 0       | 18        | 0     |

  Сценарий: Разглеждане на резултати на отворена задача
    Дадено че съм студент
    И че има отворена задача "Първа задача"
    Когато отида на решенията на "Първа задача"
    То трябва да виждам "Нямате достъп до тази страница"

  Сценарий: Разглеждане на решение
    Дадено че "Първа задача" има следните решения:
      | Студент      | Успешни | Неуспешни | Код             | Лог |
      | Петър Петров | 12      | 6         | print('larodi') | OK  |
    Когато отида на решението на "Петър Петров" за "Първа задача"
    То трябва да виждам "12 успешни тест(а)"
    И трябва да виждам "6 неуспешни тест(а)"
    И трябва да виждам "print('larodi')"
    И трябва да виждам "OK"
