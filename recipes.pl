% Danh sách công thức 

recipe('Salad Rau Tron', ['rau', 'dua leo', 'ca chua']).
recipe('Trung Chien', ['trung', 'hanh']).
recipe('Ga Ran', ['thit ga', 'bot']).
recipe('Pho Bo', ['thit bo', 'banh pho', 'rau thom', 'hanh', 'que']).
recipe('Bun Cha', ['thit heo', 'bun', 'rau song', 'nuoc mam', 'toi', 'ot']).
recipe('Com Chien Hai San', ['com', 'tom', 'muc', 'trung', 'hanh']).
recipe('Mi Xao Hai San', ['mi', 'tom', 'muc', 'rau cai', 'hanh', 'toi']).
recipe('Lau Thai', ['tom', 'muc', 'thit bo', 'nam', 'rau thom', 'sa', 'la chanh']).
recipe('Banh Mi Xiu Mai', ['banh mi', 'xiu mai', 'ca chua', 'hanh', 'toi']).
recipe('Ga Nuong Mat Ong', ['thit ga', 'mat ong', 'toi', 'sa', 'tieu']).
recipe('Com Ga Hoi An', ['thit ga', 'com', 'rau ram', 'hanh', 'nuoc mam', 'tieu']).
recipe('Lau Hai San', ['tom', 'muc', 'ca', 'rau thom', 'sa', 'la chanh', 'nam', 'ot']).
recipe('Ga Ran Pho Mai', ['thit ga', 'bot']).
recipe('Banh Mi Trung', ['banh mi', 'trung']).
recipe('Trung Hap', ['trung', 'nuoc mam']).
recipe('Khoai Tay Chien', ['khoai tay', 'dau an']).
recipe('Bap Xao', ['bap', 'hanh', 'bo']).
recipe('Trung Xao Ca Chua', ['trung', 'ca chua', 'hanh']).
recipe('Canh Rong Bien', ['rong bien', 'trung']).
recipe('Banh Trang Tron', ['banh trang', 'xoai', 'rau ram']).
recipe('Ca Chien Muoi', ['ca', 'muoi', 'dau an']).
recipe('Bo Luc Lac', ['thit bo', 'toi', 'hanh']).
recipe('Dau Hu Chien', ['dau hu', 'muoi']).
recipe('Rau Muong Xao Toi', ['rau muong', 'toi', 'dau an']).


% Nguyên liệu thay thế

replacement('thit ga', 'thit bo').
replacement('thit heo', 'thit bo').
replacement('nuoc mam', 'tuong').
replacement('xiu mai', 'cha').
replacement('mat ong', 'duong').
replacement('rau ram', 'rau thom').
replacement('sa', 'hanh').


% Tìm nguyên liệu thực tế (có thể thay)

actual_ingredient(Ingredient, Ingredients, []) :-
    member(Ingredient, Ingredients).

actual_ingredient(Ingredient, Ingredients, [Ingredient - Alt]) :-
    replacement(Ingredient, Alt),
    member(Alt, Ingredients).


% Kiểm tra nguyên liệu và lưu thay thế

all_ingredients_available([], _, []).

all_ingredients_available([H|T], Ingredients, Replacements) :-
    actual_ingredient(H, Ingredients, Info),
    all_ingredients_available(T, Ingredients, Rest),
    append(Info, Rest, Replacements).


% Gợi ý món ăn và trả về nguyên liệu đã thay

suggest_recipe(Ingredients, Recipe, Replacements) :-
    recipe(Recipe, Required),
    all_ingredients_available(Required, Ingredients, Replacements).
