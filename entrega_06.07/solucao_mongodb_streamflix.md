

```javascript
use("streamflix")
```

---

## Nível 1 — Primeiros contatos com documentos e coleções

### Exercício 1 — Liste todos os documentos da coleção `usuarios`.
```javascript
db.usuarios.find()
```
```
// Retorna os 10 usuários cadastrados:
// Ana Souza, Carlos Lima, Fernanda Rocha, João Mendes, Marina Costa,
// Rafael Oliveira, Beatriz Nunes, Lucas Ferreira, Patrícia Alves, Eduardo Martins.
```

### Exercício 2 — Liste todos os documentos da coleção `conteudos`.
```javascript
db.conteudos.find()
```
```
// Retorna os 15 conteúdos cadastrados (filmes, séries e documentários):
// Interestelar, Matrix, Avatar, O Senhor dos Anéis, A Origem, Divertida Mente,
// Cidade de Deus, Dark, Breaking Bad, Stranger Things, The Office, Planeta Terra,
// O Dilema das Redes, Senna e Parasita.
```

### Exercício 3 — Liste todos os usuários da cidade de `Curitiba`.
```javascript
db.usuarios.find({ cidade: "Curitiba" })
```
```
// Retorna 3 usuários: Ana Souza, João Mendes e Eduardo Martins.
```

### Exercício 4 — Liste todos os conteúdos do tipo `filme`.
```javascript
db.conteudos.find({ tipo: "filme" })
```
```
// Retorna 8 filmes: Interestelar, Matrix, Avatar, O Senhor dos Anéis,
// A Origem, Divertida Mente, Cidade de Deus e Parasita.
```

### Exercício 5 — Busque o conteúdo cujo título é `Matrix`.
```javascript
db.conteudos.find({ titulo: "Matrix" })
```
```
// Retorna 1 documento: Matrix (1999), tipo filme, avaliaçãoMedia 9.2.
```

### Exercício 6 — Insira um novo usuário.
```javascript
db.usuarios.insertOne({
  nome: "Gabriel Santos",
  email: "gabriel@email.com",
  idade: 26,
  cidade: "Cascavel",
  estado: "PR",
  interesses: ["Ação", "Suspense"],
  ativo: true
})
```
```
// Retorna: { acknowledged: true, insertedId: ObjectId("...") }
// A coleção usuarios passa a ter 11 documentos.
```

### Exercício 7 — Insira um novo conteúdo do tipo `filme`.
```javascript
db.conteudos.insertOne({
  titulo: "Duna",
  tipo: "filme",
  ano: 2021,
  generos: ["Ficção Científica", "Aventura"],
  avaliacaoMedia: 8.9,
  duracaoMinutos: 155,
  disponivel: true
})
```
```
// Retorna: { acknowledged: true, insertedId: ObjectId("...") }
// A coleção conteudos passa a ter 16 documentos.
```


### Exercício 8 — Conteúdos com avaliação média maior que `9`.
```javascript
db.conteudos.find({ avaliacaoMedia: { $gt: 9 } })
```
```
// Retorna: Interestelar (9.5), Matrix (9.2), O Senhor dos Anéis (9.4),
// A Origem (9.1), Dark (9.1), Breaking Bad (9.8), Planeta Terra (9.6).
```

### Exercício 9 — Usuários com idade maior que `30`.
```javascript
db.usuarios.find({ idade: { $gt: 30 } })
```
```
// Retorna: Carlos Lima (31), Marina Costa (35), Rafael Oliveira (42),
// Patrícia Alves (38) e Eduardo Martins (33).
```

### Exercício 10 — Conteúdos lançados antes do ano `2010`.
```javascript
db.conteudos.find({ ano: { $lt: 2010 } })
```
```
// Retorna: Matrix (1999), Avatar (2009), O Senhor dos Anéis (2001),
// Cidade de Deus (2002), Breaking Bad (2008), The Office (2005),
// Planeta Terra (2006).
```

### Exercício 11 — Conteúdos lançados a partir de `2015`.
```javascript
db.conteudos.find({ ano: { $gte: 2015 } })
```
```
// Retorna: Divertida Mente (2015), Dark (2017), Stranger Things (2016),
// O Dilema das Redes (2020), Parasita (2019).
```

### Exercício 12 — Avaliação média menor ou igual a `8.8`.
```javascript
db.conteudos.find({ avaliacaoMedia: { $lte: 8.8 } })
```
```
// Retorna: Avatar (8.8), Divertida Mente (8.7), Stranger Things (8.9? não),
// The Office (8.8), O Dilema das Redes (8.2), Senna (8.6).
// (Stranger Things = 8.9 NÃO entra. Entram: Avatar, Divertida Mente,
//  The Office, O Dilema das Redes, Senna.)
```

### Exercício 13 — Usuários que não são do estado `PR`.
```javascript
db.usuarios.find({ estado: { $ne: "PR" } })
```
```
// Retorna: Marina Costa (SP), Rafael Oliveira (RJ),
// Lucas Ferreira (SC), Patrícia Alves (MG).
```

---

## Nível 3 — Consultas com arrays

### Exercício 14 — Conteúdos com o gênero `Drama`.
```javascript
db.conteudos.find({ generos: "Drama" })
```
```
// Retorna: Interestelar, Cidade de Deus, Dark, Breaking Bad, Parasita.
```

### Exercício 15 — Conteúdos com o gênero `Ficção Científica`.
```javascript
db.conteudos.find({ generos: "Ficção Científica" })
```
```
// Retorna: Interestelar, Matrix, Avatar, A Origem, Dark, Stranger Things.
```

### Exercício 16 — Conteúdos com `Drama` e `Crime` ao mesmo tempo.
```javascript
db.conteudos.find({ generos: { $all: ["Drama", "Crime"] } })
```
```
// Retorna: Cidade de Deus e Breaking Bad.
```

### Exercício 17 — Usuários com interesse em `Suspense`.
```javascript
db.usuarios.find({ interesses: "Suspense" })
```
```
// Retorna: Carlos Lima, Fernanda Rocha e Eduardo Martins.
```

### Exercício 18 — Conteúdos com `Terror` ou `Mistério`.
```javascript
db.conteudos.find({ generos: { $in: ["Terror", "Mistério"] } })
```
```
// Retorna: Dark (Mistério), Stranger Things (Terror).
```

### Exercício 19 — Conteúdos que não possuem o gênero `Comédia`.
```javascript
db.conteudos.find({ generos: { $ne: "Comédia" } })
```
```
// Retorna todos os conteúdos EXCETO Divertida Mente e The Office.
```

---

## Nível 4 — Objetos aninhados

### Exercício 20 — Conteúdos dirigidos por `Christopher Nolan`.
```javascript
db.conteudos.find({ "diretor.nome": "Christopher Nolan" })
```
```
// Retorna: Interestelar e A Origem.
```

### Exercício 21 — Conteúdos cujo diretor é do `Reino Unido`.
```javascript
db.conteudos.find({ "diretor.pais": "Reino Unido" })
```
```
// Retorna: Interestelar e A Origem (ambos de Christopher Nolan).
```

### Exercício 22 — Usuários cujo bairro seja `Centro`.
```javascript
db.usuarios.find({ "endereco.bairro": "Centro" })
```
```
// Retorna: Ana Souza.
```

### Exercício 23 — Usuários que possuem o campo `endereco`.
```javascript
db.usuarios.find({ endereco: { $exists: true } })
```
```
// Retorna: Ana Souza e Carlos Lima (únicos com o campo endereco).
```

### Exercício 24 — Usuários que não possuem o campo `endereco`.
```javascript
db.usuarios.find({ endereco: { $exists: false } })
```
```
// Retorna os demais usuários: Fernanda, João, Marina, Rafael,
// Beatriz, Lucas, Patrícia, Eduardo (e Gabriel, se criado no Ex.6).
```

---

## Nível 5 — Atualizações básicas

### Exercício 25 — `Carlos Lima` → `ativo: true`.
```javascript
db.usuarios.updateOne(
  { nome: "Carlos Lima" },
  { $set: { ativo: true } }
)
```
```
// Retorna: matchedCount: 1, modifiedCount: 1.
// Carlos Lima passa a ter ativo: true.
```

### Exercício 26 — `Cidade de Deus` → `disponivel: true`.
```javascript
db.conteudos.updateOne(
  { titulo: "Cidade de Deus" },
  { $set: { disponivel: true } }
)
```
```
// Retorna: matchedCount: 1, modifiedCount: 1.
```

### Exercício 27 — Adicionar `idiomaOriginal: "Inglês"` a `Matrix`.
```javascript
db.conteudos.updateOne(
  { titulo: "Matrix" },
  { $set: { idiomaOriginal: "Inglês" } }
)
```
```
// Retorna: matchedCount: 1, modifiedCount: 1.
// Matrix passa a ter o novo campo idiomaOriginal.
```

### Exercício 28 — Adicionar `classificacao: "10+"` a `Interestelar`.
```javascript
db.conteudos.updateOne(
  { titulo: "Interestelar" },
  { $set: { classificacao: "10+" } }
)
```
```
// Retorna: matchedCount: 1, modifiedCount: 1.
```

### Exercício 29 — Avaliação média de `Avatar` → `9.0`.
```javascript
db.conteudos.updateOne(
  { titulo: "Avatar" },
  { $set: { avaliacaoMedia: 9.0 } }
)
```
```
// Retorna: matchedCount: 1, modifiedCount: 1.
```

---

## Nível 6 — Atualizações com operadores

### Exercício 30 — Incrementar em `1` as visualizações de `Matrix`.
```javascript
db.conteudos.updateOne(
  { titulo: "Matrix" },
  { $inc: { visualizacoes: 1 } }
)
```
```
// Retorna: modifiedCount: 1.
// visualizacoes de Matrix: 3100000 -> 3100001.
```

### Exercício 31 — Incrementar em `1000` as visualizações de todos os disponíveis.
```javascript
db.conteudos.updateMany(
  { disponivel: true },
  { $inc: { visualizacoes: 1000 } }
)
```
```
// Retorna: modifiedCount igual ao nº de conteúdos disponíveis (13, já que
// Cidade de Deus foi tornado disponível no Ex.26; Senna continua indisponível).
```

### Exercício 32 — Adicionar o gênero `Clássico` a `Matrix`.
```javascript
db.conteudos.updateOne(
  { titulo: "Matrix" },
  { $push: { generos: "Clássico" } }
)
```
```
// Retorna: modifiedCount: 1.
// generos de Matrix: ["Ação", "Ficção Científica", "Clássico"].
```

### Exercício 33 — Remover o gênero `Clássico` de `Matrix`.
```javascript
db.conteudos.updateOne(
  { titulo: "Matrix" },
  { $pull: { generos: "Clássico" } }
)
```
```
// Retorna: modifiedCount: 1.
// generos de Matrix volta a: ["Ação", "Ficção Científica"].
```

### Exercício 34 — Remover o campo `telefone` de `Beatriz Nunes`.
```javascript
db.usuarios.updateOne(
  { nome: "Beatriz Nunes" },
  { $unset: { telefone: "" } }
)
```
```
// Retorna: modifiedCount: 1.
// O documento de Beatriz Nunes deixa de ter o campo telefone.
```

### Exercício 35 — Adicionar benefício `sem anúncios` às assinaturas `Premium`.
```javascript
db.assinaturas.updateMany(
  { plano: "Premium" },
  { $push: { beneficios: "sem anúncios" } }
)
```
```
// Retorna: modifiedCount: 2 (assinaturas de ana@ e marina@).
```

---

## Nível 7 — Operadores lógicos

### Exercício 36 — Filmes com avaliação média maior que `9`.
```javascript
db.conteudos.find({
  $and: [ { tipo: "filme" }, { avaliacaoMedia: { $gt: 9 } } ]
})
```
```
// Retorna: Interestelar (9.5), Matrix (9.2), O Senhor dos Anéis (9.4),
// A Origem (9.1). (Avatar = 9.0 não entra por não ser > 9.)
```

### Exercício 37 — Usuários de `Curitiba` ou `Maringá`.
```javascript
db.usuarios.find({
  $or: [ { cidade: "Curitiba" }, { cidade: "Maringá" } ]
})
```
```
// Retorna: Ana Souza, João Mendes, Eduardo Martins (Curitiba)
// e Carlos Lima, Beatriz Nunes (Maringá).
```

### Exercício 38 — Conteúdos que são séries ou documentários.
```javascript
db.conteudos.find({ tipo: { $in: ["serie", "documentario"] } })
```
```
// Retorna: Dark, Breaking Bad, Stranger Things, The Office (séries)
// e Planeta Terra, O Dilema das Redes, Senna (documentários).
```

### Exercício 39 — Avaliação maior que `9` e visualizações acima de `2000000`.
```javascript
db.conteudos.find({
  $and: [
    { avaliacaoMedia: { $gt: 9 } },
    { visualizacoes: { $gt: 2000000 } }
  ]
})
```
```
// Com base nos dados originais retorna: Interestelar, Matrix,
// O Senhor dos Anéis, Dark, Breaking Bad.
// (Obs.: valores de visualizacoes podem ter sido alterados pelos Ex.30 e 31.)
```

### Exercício 40 — Usuários ativos com idade menor que `30`.
```javascript
db.usuarios.find({
  $and: [ { ativo: true }, { idade: { $lt: 30 } } ]
})
```
```
// Retorna: Ana Souza (22), João Mendes (19), Beatriz Nunes (24),
// Lucas Ferreira (29). (Fernanda 27 também é ativa -> entra.)
```

---

## Nível 8 — Campos opcionais e flexibilidade NoSQL

### Exercício 41 — Conteúdos que possuem o campo `premios`.
```javascript
db.conteudos.find({ premios: { $exists: true } })
```
```
// Retorna: O Senhor dos Anéis (Oscar, BAFTA) e Parasita (Oscar).
```

### Exercício 42 — Conteúdos que não possuem o campo `diretor`.
```javascript
db.conteudos.find({ diretor: { $exists: false } })
```
```
// Retorna: Divertida Mente, Dark, Breaking Bad, Stranger Things,
// The Office, Planeta Terra, O Dilema das Redes, Senna.
```

### Exercício 43 — Usuários que possuem o campo `premium`.
```javascript
db.usuarios.find({ premium: { $exists: true } })
```
```
// Retorna: Marina Costa (premium: true) e Eduardo Martins (premium: false).
```

### Exercício 44 — Conteúdos que possuem o campo `temporadas`.
```javascript
db.conteudos.find({ temporadas: { $exists: true } })
```
```
// Retorna as séries: Dark, Breaking Bad, Stranger Things, The Office.
```

### Exercício 45 — Explique por que os documentos de `conteudos` podem ter campos diferentes.
```javascript
// Resposta (conceitual):
// O MongoDB é um banco orientado a documentos e NÃO impõe um esquema fixo
// (schema-less / schema flexível). Cada documento de uma mesma coleção pode
// ter campos distintos. Assim, filmes têm "duracaoMinutos", séries têm
// "temporadas" e "episodios", e documentários podem ter "narrador".
// Isso permite modelar entidades semelhantes, mas não idênticas, na mesma
// coleção, adaptando os campos à natureza de cada conteúdo.
```

---

## Nível 9 — Remoção de documentos

### Exercício 46 — Remova o usuário criado no Exercício 6.
```javascript
db.usuarios.deleteOne({ email: "gabriel@email.com" })
```
```
// Retorna: deletedCount: 1.
```

### Exercício 47 — Remova o conteúdo criado no Exercício 7.
```javascript
db.conteudos.deleteOne({ titulo: "Duna" })
```
```
// Retorna: deletedCount: 1.
```

### Exercício 48 — Remova todas as avaliações com nota menor que `8`.
```javascript
db.avaliacoes.deleteMany({ nota: { $lt: 8 } })
```
```
// Retorna: deletedCount: 0 (todas as avaliações têm nota >= 8).
```

### Exercício 49 — Remova históricos com progresso menor que `40`.
```javascript
db.historico.deleteMany({ progressoPercentual: { $lt: 40 } })
```
```
// Retorna: deletedCount: 1 (registro de patricia@ / Senna, progresso 30).
```

---

## Nível 10 — Consultas em coleções diferentes

### Exercício 50 — Liste todas as assinaturas ativas.
```javascript
db.assinaturas.find({ ativo: true })
```
```
// Retorna as assinaturas de: ana@, fernanda@, marina@, lucas@, eduardo@.
// (carlos@ está com ativo: false.)
```

### Exercício 51 — Liste todas as assinaturas do plano `Premium`.
```javascript
db.assinaturas.find({ plano: "Premium" })
```
```
// Retorna as assinaturas de: ana@email.com e marina@email.com.
```

### Exercício 52 — Histórico de visualização de `ana@email.com`.
```javascript
db.historico.find({ usuarioEmail: "ana@email.com" })
```
```
// Retorna 2 registros: Interestelar (100%, finalizado)
// e Dark (T1E3, 45%, não finalizado).
```

### Exercício 53 — Conteúdos finalizados no histórico.
```javascript
db.historico.find({ finalizado: true })
```
```
// Retorna: Interestelar (ana), Matrix (carlos), Planeta Terra (marina),
// The Office (beatriz), Parasita (eduardo).
```

### Exercício 54 — Avaliações com nota igual a `10`.
```javascript
db.avaliacoes.find({ nota: 10 })
```
```
// Retorna 3 avaliações: ana@/Interestelar, marina@/Planeta Terra,
// eduardo@/Parasita.
```

### Exercício 55 — Usuários que possuem assinatura ativa (consulta em 2 etapas).
```javascript
// 1) Obter os e-mails com assinatura ativa:
db.assinaturas.find({ ativo: true }, { usuarioEmail: 1, _id: 0 })

// 2) Buscar os usuários correspondentes:
db.usuarios.find({
  email: { $in: [
    "ana@email.com", "fernanda@email.com", "marina@email.com",
    "lucas@email.com", "eduardo@email.com"
  ] }
})
```
```
// Retorna os usuários: Ana Souza, Fernanda Rocha, Marina Costa,
// Lucas Ferreira e Eduardo Martins.
```

---

## Nível 11 — Introdução à agregação

### Exercício 56 — Conte quantos documentos existem em `conteudos`.
```javascript
db.conteudos.countDocuments()
```
```
// Retorna: 15 (considerando que o conteúdo do Ex.7 foi removido no Ex.47).
```

### Exercício 57 — Conte quantos conteúdos existem por tipo.
```javascript
db.conteudos.aggregate([
  { $group: { _id: "$tipo", total: { $sum: 1 } } }
])
```
```
// Retorna aproximadamente:
// { _id: "filme", total: 8 }
// { _id: "serie", total: 4 }
// { _id: "documentario", total: 3 }
```

### Exercício 58 — Média das avaliações médias dos conteúdos.
```javascript
db.conteudos.aggregate([
  { $group: { _id: null, mediaGeral: { $avg: "$avaliacaoMedia" } } }
])
```
```
// Retorna um único documento com mediaGeral ≈ 9.03
// (média das avaliaçõesMedia de todos os conteúdos).
```

### Exercício 59 — Conteúdos ordenados pela avaliação média (decrescente).
```javascript
db.conteudos.find().sort({ avaliacaoMedia: -1 })
```
```
// Ordem: Breaking Bad (9.8), Planeta Terra (9.6), Interestelar (9.5),
// O Senhor dos Anéis (9.4), Matrix (9.2), A Origem (9.1), Dark (9.1)...
// ... até O Dilema das Redes (8.2).
```

### Exercício 60 — Cinco conteúdos com maior número de visualizações.
```javascript
db.conteudos.find().sort({ visualizacoes: -1 }).limit(5)
```
```
// Top 5 (dados originais): Breaking Bad (4.2M), Stranger Things (3.9M),
// The Office (3.3M), Matrix (3.1M), Avatar (2.8M).
// (Pode variar levemente por causa dos incrementos dos Ex.30/31.)
```

### Exercício 61 — Média das notas da coleção `avaliacoes`.
```javascript
db.avaliacoes.aggregate([
  { $group: { _id: null, mediaNotas: { $avg: "$nota" } } }
])
```
```
// Retorna mediaNotas ≈ 9.13 (média de 10,9,9,10,8,9,10,8).
```

### Exercício 62 — Quantas avaliações cada conteúdo recebeu.
```javascript
db.avaliacoes.aggregate([
  { $group: { _id: "$tituloConteudo", total: { $sum: 1 } } }
])
```
```
// Cada conteúdo avaliado recebeu 1 avaliação:
// Interestelar, Matrix, Dark, Planeta Terra, Stranger Things,
// The Office, Parasita, O Dilema das Redes -> total: 1 cada.
```

### Exercício 63 — Quantos usuários existem por estado.
```javascript
db.usuarios.aggregate([
  { $group: { _id: "$estado", total: { $sum: 1 } } }
])
```
```
// Retorna: PR: 6, SP: 1, RJ: 1, SC: 1, MG: 1.
```

---

## Nível 12 — Desafio de modelagem NoSQL

### Exercício 64 — Crie a coleção `perfis_completos` (dados incorporados).
```javascript
db.perfis_completos.insertOne({
  nome: "Ana Souza",
  email: "ana@email.com",
  idade: 22,
  assinatura: {
    plano: "Premium",
    ativo: true,
    valorMensal: 49.90
  },
  historico: [
    {
      tituloConteudo: "Interestelar",
      progressoPercentual: 100,
      finalizado: true
    },
    {
      tituloConteudo: "Dark",
      temporada: 1,
      episodio: 3,
      progressoPercentual: 45,
      finalizado: false
    }
  ]
})
```
```
// Retorna: { acknowledged: true, insertedId: ObjectId("...") }
// Cria um documento único que reúne usuário + assinatura + histórico (embedding).
```

### Exercício 65 — Coleções separadas vs. documento único.
```javascript
// Resposta (conceitual):
// - Separado (referências): dados normalizados, sem duplicação; atualizar uma
//   informação em um único lugar; ideal quando os dados crescem muito ou são
//   compartilhados. Porém exige várias consultas/junções manuais para reunir tudo.
// - Documento único (embedding): todos os dados relacionados vêm em uma só
//   leitura, ótimo desempenho de leitura e simplicidade. Porém pode gerar
//   duplicação, documentos grandes e dificuldade de manter consistência quando
//   a mesma informação aparece em vários documentos.
```

### Exercício 66 — Vantagem e desvantagem de documentos aninhados.
```javascript
// Resposta (conceitual):
// Vantagem: leitura rápida e atômica — os dados relacionados ficam juntos,
//           evitando junções e reduzindo o número de consultas.
// Desvantagem: pode causar duplicação e documentos muito grandes, além de
//              dificultar atualizações quando o mesmo dado se repete em vários
//              documentos (risco de inconsistência).
```

### Exercício 67 — Quando usar referência entre coleções.
```javascript
// Resposta (conceitual):
// Usar referência quando: os dados têm relação muitos-para-muitos; a entidade
// referenciada é grande ou muda com frequência; a mesma informação é compartilhada
// por muitos documentos; ou quando o documento cresceria demais (limite de 16MB).
// Ex.: um mesmo conteúdo referenciado por milhares de avaliações.
```

### Exercício 68 — Quando usar dados incorporados (embedding).
```javascript
// Resposta (conceitual):
// Usar embedding quando: os dados são lidos sempre juntos; a relação é
// um-para-poucos e "de posse" (o filho não existe sem o pai); e os dados
// embutidos não crescem indefinidamente. Ex.: endereço dentro do usuário,
// ou o histórico e a assinatura dentro do perfil do usuário.
```
