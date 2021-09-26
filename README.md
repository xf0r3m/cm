# CM - Connection Manager

__CM__ - prosty skrypt ułatwiający łączenie się z odległymi komputerami za pomocą protokołu SSH. Użycie klucz publicznych
do logowania się na serwer poprawnia znacząco korzystanie ze skryptu. Skrypt umożliwia wydanie polecenia całej lisćie 
hostów, lub wybranemu przez nasz zakresowi z listy.

__Instalacja:__

1. git clone https://github.com/xf0r3m/cm.git
2. Tworzymy katalog domowy
3. Tworzymy listę oraz definiujemy domyślnego użytkownika
4. chmod +x cm/cm.sh 
5. Uruchomienie: ./cm/cm.sh  



__Katalog domowy:__

`$HOME/.cm`

Pliki programu:

`$HOME/.cm/list` - domyślna lista serwerów.

`$HOME/.cm/user` - domyślny użytkownik.

__Słownik:__

* index - liczba porządkowa na liście serwerów.
* lista indeksów - indeksy oddzielone przecinkiem.
* zakres mieszany - połączenie zakresu od-do z listą indeksów.
    Lista indeksów ma wiekszy priorytet, niż zakres.

__Opcje programu:__

`-a` - przetwarzanie wsadowe dla wszystkich serwerów z listy
(użycie opcji `-c <polecenie>`, wymagane).

`-b <zakres/lista indeksów/zakres mieszany>` - przetwarzanie wsadowe
(użycie opcji `-c <polecenie>`, wymagane).

`-c <polecenie>` - polecenie do zdalnego wykonania.

`-h` - wyświetlenie pomocy.

`-i <index>` - połączenie z systemem o podanym indeksie.

`-l <ścieżka_do_listy>` - użycie innej listy niż domyślna.

`-p ssh/[sftp]` - wybór protokołu, domyślnie: ssh.

`-u <użytkownik>` - użycie innego użytkownika niz domyślny.

`-s <list/user>` - wyświetla listę lub użytkownik
