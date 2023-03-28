#include <iostream>
#include <vector>
#include <algorithm>
#include <cassert>
#include <fstream>
#include <ctime>
using namespace std;
// Dyskretny problem plecakowy - metoda zachłanna
// Struktura przechowująca informacje o przedmiocie
struct Item {
    double value;  // wartość przedmiotu
    int weight;  // waga przedmiotu
};
// Porównywanie przedmiotów według stosunku wartości do wagi
bool cmp(Item a, Item b) {
    double r1 = a.value / a.weight;
    double r2 = b.value / b.weight;
    return r1 > r2;
}
double knapsack(int W, vector<Item> items) {
    // sortujemy przedmioty według stosunku wartości do wagi
    sort(items.begin(), items.end(), cmp);

    int currentWeight = 0;  // obecny ciężar plecaka
    double finalValue = 0.0;  // końcowa wartość przedmiotów w plecaku

    // Dopóki miejsce w plecaku i są jeszcze przedmioty do wzięcia
    for (int i = 0; W > 0 && i < items.size(); i++) {
        // Jeśli cały przedmiot mieści się w plecaku
        if (i >= items.size()) {
            break;
        }
        if (currentWeight + items[i].weight <= W) {
            currentWeight += items[i].weight;  // dodajemy cały przedmiot
            finalValue += items[i].value;  // dodajemy jego wartość do końcowej wartości
        }
        else {
            break;  // wychodzimy z pętli, bo już nic nie zmieścimy
        }
    }

    return finalValue;
}
// Dyskretny problem plecakowy - metoda dynamiczna
// n - liczba przedmiotów
// W - pojemność plecaka
// wt - tablica wag przedmiotów
// val - tablica wartości przedmiotów
int dynamicknapsack(int n, int W, vector<int>& wt, vector<int>& val) {
    // Tworzenie tablicy do przechowywania wartości
    vector<vector<int>> dp(n + 1, vector<int>(W + 1));
    // Inicjalizacja tablicy
    for (int i = 0; i <= n; i++) {
        for (int w = 0; w <= W; w++) {
            if (i == 0 || w == 0)
                dp[i][w] = 0;
            else if (wt[i - 1] <= w)
                dp[i][w] = max(val[i - 1] + dp[i - 1][w - wt[i - 1]], dp[i - 1][w]);
            else
                dp[i][w] = dp[i - 1][w];
        }
    }
    return dp[n][W];
}
double fractionalKnapsack(int W, vector<Item> items) {
    // sortujemy przedmioty według stosunku wartości do wagi
    sort(items.begin(), items.end(), cmp);

    int currentWeight = 0;  // obecny ciężar plecaka
    double finalValue = 0.0;  // końcowa wartość przedmiotów w plecaku

    // Dopóki miejsce w plecaku i są jeszcze przedmioty do wzięcia
    for (int i = 0; W > 0 && i < items.size(); i++) {
        // Jeśli cały przedmiot mieści się w plecaku
        if (currentWeight + items[i].weight <= W) {
            currentWeight += items[i].weight;  // dodajemy cały przedmiot
            finalValue += items[i].value;  // dodajemy jego wartość do końcowej wartości
        }
        else {
            // W przeciwnym wypadku wzięcie całego przedmiotu by przekroczyło pojemność plecaka
            int remaining = W - currentWeight;  // obliczamy ile jeszcze możemy schować
            finalValue += items[i].value * ((double)remaining / items[i].weight);  // obliczamy wartość części przedmiotu
            break;  // wychodzimy z pętli, bo już nic nie zmiescimy
        }
    }

    return finalValue;
}
int dynamicKnapsack(int n, int W, vector<int>& wt, vector<int>& val) {
    // Tworzenie tablicy do przechowywania wartości
    vector<vector<int>> dp(n + 1, vector<int>(W + 1));
    // Inicjalizacja tablicy
    for (int i = 0; i <= n; i++) {
        for (int w = 0; w <= W; w++) {
            if (i == 0 || w == 0)
                dp[i][w] = 0;
            else if (wt[i - 1] <= w)
                dp[i][w] = max(val[i - 1] + dp[i - 1][w - wt[i - 1]], dp[i - 1][w]);
            else
                dp[i][w] = dp[i - 1][w];
        }
    }
    return dp[n][W];
}
void test() {
    int W = 50;
    vector<Item> items = { {40, 25}, {68, 42}, {56, 20} };
    double result = knapsack(W, items);
    double expected = 96;
    double epsilon = 0.0001;
    if (abs(result - expected) < epsilon)
        cout << "Optymalne rozwiazanie" << endl;
    else
        cout << "Nieoptymalne rozwiazanie" << endl;
}
void testDynamicKnapsack() {
    int W = 50;
    vector<Item> items = { {40, 25}, {68, 42}, {56, 20} };
    vector<int> weight;
    vector<int> values;
    for (auto i : items) {
        weight.push_back(i.weight);
        values.push_back(i.value);
    }
    int result = dynamicKnapsack(items.size(), W, weight, values);
    double expected = 96;
    if (result == expected)
        cout << "Optymalne rozwiazanie" << endl;
    else
        cout << "Nieoptymalne rozwiazanie" << endl;
}
double evaluateDynamic(int W, vector<int>& wt, vector<int>& val) {
    int dynamicValue = dynamicKnapsack(wt.size(), W, wt, val);
    // Obliczanie optymalnej wartości dla problemu plecakowego (np. przy użyciu metody dynamicznej)
    double optimalValue = dynamicKnapsack(wt.size(), W, wt, val);
    cout << "Wartosc uzyskana metoda dynamicznej: " << dynamicValue << endl;
    cout << "Optymalna wartosc dla problemu: " << optimalValue << endl;
    return dynamicValue / optimalValue;
}
double evaluateGreedy(int W, vector<Item> items, vector<int>& wt, vector<int>& val) {
    double greedyValue = knapsack(W, items);
    // Obliczanie optymalnej wartości dla problemu plecakowego (np. przy użyciu metody dynamicznej)
    double optimalValue = dynamicKnapsack(items.size(), W, wt, val);
    cout << "Wartosc uzyskana metoda zachlanna: " << greedyValue << endl;
    cout << "Optymalna wartosc dla problemu: " << optimalValue << endl;
    return greedyValue / optimalValue;

}
double evaluateFractional(int W, vector<Item> items) {
    double fractionalValue = fractionalKnapsack(W, items);;
    cout << "Wartosc uzyskana metoda zachlannego plecaka frakcjonalnego: " << fractionalValue << endl;
    return 1;
}
void evaluateAll(int W, vector<Item> items, vector<int> wt, vector<int> val) {
    cout << "Ocena optymalizacji metody zachlannej: " << evaluateGreedy(W, items, wt, val) << endl;
    cout << endl;
    cout << "Ocena optymalizacji metody dynamicznej: " << evaluateDynamic(W, wt, val) << endl;
    cout << endl;
    cout << "Ocena optymalizacji metody frakcjonalnego plecaka: " << evaluateFractional(W, items) << endl;
}
int main() {
    //Tworzenie odpowiedniej liczby elementow
    int num_items = 30000;
    int knapsack_capacity = 1000000;

    ofstream dataFile;
    dataFile.open("data.txt");

    dataFile << num_items << " " << knapsack_capacity << endl;
    for (int i = 0; i < num_items; i++) {
        int value = rand() % 10 + 1;
        int weight = rand() % 10 + 1;
        dataFile << value << " " << weight << endl;
    }

    dataFile.close();
    int n = 0, w, W;
    cout << "Podaj pojemnosc plecaka: ";
    cin >> W;
    cout << endl;
    int v;
    fstream data;
    data.open("data.txt", ios::in);
    if (!data.good()) {
        cout << "Problem z plikiem" << endl;
    }
    else {
        vector<Item> items;
        vector<Item> items2;
        vector<int> wt;
        vector<int> val;
        while (!data.eof()) {

            data >> v >> w;
            items.push_back(Item());
            items2.push_back(Item());
            items[n].value = v;
            items2[n].value = v;
            items[n].weight = w;
            items2[n].weight = w;
            val.push_back(v);
            wt.push_back(w);
            n++;
        }
        cout << "\033[32mDYSKRETNY PROBLEM PLECAKOWY - ROZWIAZANIE ZACHLANNE\033[0m" << endl;
        clock_t start = clock();
        cout << "Wynik: " << knapsack(W, items) << endl;
        clock_t end = clock();
        double result_time1 = (double)(end - start) / CLOCKS_PER_SEC;
        test();
        cout << "Czas: " << result_time1 << "s";
        cout << endl;
        cout << endl;
        cout << "\033[32mDYSKRETNY PROBLEM PLECAKOWY - ROZWIAZANIE DYNAMICZNE\033[0m" << endl;
        start = clock();
        cout << "Wynik: " << dynamicknapsack(n, W, wt, val) << endl;
        testDynamicKnapsack();
        end = clock();
        double result_time2 = (double)(end - start) / CLOCKS_PER_SEC;
        cout << "Czas: " << result_time2 << "s";
        cout << endl;
        cout << endl;
        cout << "\033[32mCIAGLY PROBLEM PLECAKOWY\033[0m" << endl;
        start = clock();
        cout << "Wynik: " << fractionalKnapsack(W, items) << endl;
        end = clock();
        double result_time3 = (double)(end - start) / CLOCKS_PER_SEC;
        cout << "Czas: " << result_time3 << "s";
        cout << endl;
        cout << endl;    
        cout << "\033[31mOCENA\033[0m" << endl;   
        evaluateAll(W, items, wt, val); 
    }
    data.close();
    return 0;
}