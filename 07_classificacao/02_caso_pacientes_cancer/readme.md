## Definição do Desafio

- Considera-se o conjunto de dados de $683$ pacientes de um centro médico. Cada paciente é categorizado de acordo com sua condição médica ($2$ para "tem câncer" e $4$ para "não tem câncer").

- Busca-se desenvolver um sistema capaz de prever a condição oncológica de futuros pacientes com base em nove ($9$) características específicas.

- ## Quadro geral do desafio

- Como se espera usar e se beneficiar desse modelo? A saida do modelo será a classificação de pacientes segundo sua condição de saúde. Este sistema determinará quais paciêntes devem ser encaminhados para tratamento. Não alimenta outro sistema. 

- Como é a solução atual? O especilista médica olha e determina quais pacientes e determinam a condição de saúde dos mesmos. O que implica bastantes regras e um alto valor.

- ## Sistema, tarefa e ténica de ML

- Qual tipo de supervisão de treinamento será necessário para o modelo? Será necessário um sistema de *ML* supervisionado, uma vez que que os individus são rotulados por sua condição médica. 

- Qual será a tarefa desempenhada pelo modelo? Clasificação do estado de saúde dos paciente. Consideram-se os modelos: `Logistic Regression`, `K-Nearest Neighbors (K-NN)`, `Support Vector Machine (SVM)`, `Kernel SVM`, `Naive Bayes`, `Decision Tree Classification`, e `Random Forest Classification`.

- Deve-se utilizar técnicas de aprendizado em lote ou em tempo real? Por lote, uma vez que o banco de dados não é atualizado rápidamente. 
