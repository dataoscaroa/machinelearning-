# Definição do Desafio

- Considera-se o conjunto de dados de $400$ clientes de uma empresa de carro. Cada paciente é categorizado de acordo com sua condição de compra ($0$ para "não comprou" e $4$ para "comprou").

- Busca-se desenvolver um sistema capaz de prever as compras de futuros clientes com base em nove ($2$) características específicas.

- ## Quadro geral do desafio

- Como se espera usar e se beneficiar desse modelo? A saida do modelo será a classificação dos clientes segundo seu estatus de compra. Este sistema determinará quais pacientes devem ser considerados para a nova campanha de marketing. Não alimenta outro sistema. 

- Como é a solução atual? O especilista olha e determina quais compradores e determinam a condição dos mesmos. O que implica bastantes regras e um alto valor.

- ## Sistema, tarefa e ténica de ML

- Qual tipo de supervisão de treinamento será necessário para o modelo? Será necessário um sistema de *ML* supervisionado, uma vez que que os individus são rotulados por sua condição de compra. Consideram-se os modelos: `Logistic Regression`, `K-Nearest Neighbors (K-NN)`, `Support Vector Machine (SVM)`, `Kernel SVM`, `Naive Bayes`, `Decision Tree Classification`, e `Random Forest Classification`.

- Qual será a tarefa desempenhada pelo modelo? Clasificação dos compradores. 

- Deve-se utilizar técnicas de aprendizado em lote ou em tempo real? Por lote, uma vez que o banco de dados não é atualizado rápidamente. 
