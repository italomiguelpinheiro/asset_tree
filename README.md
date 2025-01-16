# TRACTIAN Challenges - Asset Tree Mobile

### Details
- Possível utilizar de forma offline;
- Otimização de perfomance: Utilizei multithereads para o processamento dos dados das entidades para inserção no banco de dados 
- Otimização de perfomance: Utilizei Transactions para inserção dos dados no banco.
- Busca otimizadas na árvore com early stop para acelerar a filtragem.

### Packages
- GetX
- Dio
- Sqflite
- Connectivity_plus

### Video
- No video abaixo eu descrevo todo o processo de construção do app:
-- 1. Telas
-- 2. Código e explicação
-- 3. Melhorias que poderiam ser implementadas.

- [Clique aqui para assistir](https://drive.google.com/file/d/1FKPdM6pb7YfkAXXu1izMCK-KIXmDVsmq/view?usp=sharing)

### Possible Improvements
- Fazer requisições em chunks 
- Seria bom se no retorno das locations e assets tivessem a companyId em que este faz parte, pois facilitaria a inserção e busca no cache do aplicativo
- Eu melhoraria o UI/UX e também o código do componente AssetTreeWidget. 
- Criaria uma job para atualizar os cache em background.
- Criaria testes unitários, de integração e end to end.
- Traduções para portugues e inglês dos textos
- Melhoria tambem a responsividade para tablets.    
