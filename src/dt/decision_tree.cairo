use core::array::SpanTrait;
use core::box::BoxTrait;
use core::clone::Clone;
use core::traits::Index;
use core::debug::PrintTrait;
use array::ArrayTrait;
use option::OptionTrait;
use dict::Felt252Dict;
use dict::Felt252DictTrait;
use array::Array;
use integer::BoundedInt;

use traits::TryInto;
use traits::Into;

use decision_tree::onnx_cairo::operators::math::int64;
use decision_tree::onnx_cairo::operators::math::int64::i64;
use decision_tree::onnx_cairo::operators::math::matrix::Matrix;
use decision_tree::onnx_cairo::operators::math::matrix::MatrixTrait;

#[derive(Drop)]
struct DecisionTree {
    X: Matrix,
    y: Matrix,
    score: u64
}

#[derive(Drop)]
struct BestSplit {
    score: u64,
    bestsplit: u64
}

trait DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree;
    fn find_split(self: @DecisionTree, column: u64) -> BestSplit;
}

impl DTImpl of DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree {
        create_new(X, y)
    }

    fn find_split(self: @DecisionTree, column: u64) -> BestSplit {
        let X = self.X;
        let y = self.y;
        let score = self.score;
        let X_len: u64 = self.X.cols.clone().into();
        let bestsplit = BestSplit { score: 0_u64, bestsplit: 0_u64 };
        let mut i = 0_u64;

        let mut bestsplit = find_each_split(@X.get_column(column.try_into().unwrap()), y, score);
        bestsplit
    }
}

fn create_new(X: Matrix, y: Matrix) -> DecisionTree {
    DecisionTree { X: X, y: y, score: 100_u64 }
}

fn class_count(value: @Matrix) -> Felt252Dict<felt252> {
    let mut dict: Felt252Dict<felt252> = Felt252DictTrait::new();
    let data_len = value.len();

    let mut counter: usize = 0;
    loop {
        if counter == data_len {
            break ();
        }
        let mut data = value.get(counter, 0_u32);
        let key: felt252 = data.mag.into();
        let val = dict.get(key);
        dict.insert(key, val + 1);
        counter += 1;
    };
    dict
}

fn calculate_gini(value: @Matrix) -> u64 {
    let data_len = value.len();
    let mut counts = class_count(value);
    let mut impurity = 100_u64;
    let mut counter: felt252 = 0;
    let mut array = unique_array(value);
    let array_len = array.len();

    loop {
        if counter == array_len.into() {
            break ();
        }
        let value = counts.get(array.pop_front().unwrap());
        let val: u64 = value.try_into().unwrap();
        let probability: u64 = val * impurity / data_len.into();

        impurity -= (probability * probability) / impurity;
        counter += 1;
    };
    ////////////////////
    // let mut i = 0;

    // loop {
    //     if i == data_len.into() {
    //         break ();
    //     }
    //     let dd = *value.data.at(i).mag;
    //     dd.print();
    //     i += 1;
    // };
    //////////////////////////
    impurity
}

fn unique_array(value: @Matrix) -> Array<felt252> {
    let mut counter: felt252 = 0;
    let data_len = value.len();
    let mut a = ArrayTrait::new();
    let mut counts = class_count(value);

    loop {
        if counter == data_len.into() {
            break ();
        }

        let mut val = counts.index(counter);
        if val == 0 { // 'nothing'.print();
        } else {
            a.append(counter)
        }
        counter += 1;
    };
    a
}

fn get_unique_values(value: @Array<i64>) -> Array<u64> {
    let mut unique_values = ArrayTrait::<u64>::new();
    let value_clone = value.span();
    let value_len = value_clone.len();
    let mut i = 0;

    loop {
        let mut j = 0;
        let mut is_unique = true;
        if i == value_len {
            break ();
        }
        let unique_values_clone = unique_values.span();

        loop {
            if j == unique_values_clone.len() {
                break ();
            }
            let value_i: u64 = value_clone.at(i).clone().mag;
            let values_j = unique_values_clone.at(j).clone();

            if value_i == values_j {
                is_unique = false;
                break ();
            }
            j += 1;
        };
        let value_i: u64 = (*value.at(i)).mag;

        if is_unique == true {
            unique_values.append(value_i);
        }

        i += 1;
    };
    unique_values
}

fn find_each_split(X: @Array<i64>, y: @Matrix, score: @u64) -> BestSplit {
    let mut dict: Felt252Dict<felt252> = Felt252DictTrait::new();
    let data = X;
    let y = y;
    let mut scores = score;
    let data_span = data.span();
    let data_len = data_span.len();

    let arr = get_unique_values(data);
    let arr_span = arr.span();
    let arr_len = arr_span.len();

    let mut i = 0;
    let mut best_split_value = 0;

    loop {
        if i == arr_len {
            break ();
        }
        let mut j = 0;

        let mut lhs = ArrayTrait::new();
        let mut rhs = ArrayTrait::new();

        loop {
            if j == data_len {
                break ();
            }

            let out = y.get(j, 0);

            let tt = *arr_span.at(i);
            let dd = *data_span.at(j).mag;

            if *data_span.at(j).mag > *arr_span.at(i) {
                lhs.append(out)
            } else {
                rhs.append(out)
            }

            j += 1;
        };

        let lhs_len = lhs.len();
        let rhs_len = rhs.len();

        let lhs_matrix = MatrixTrait::new(lhs_len, 1_u32, lhs);
        let rhs_matrix = MatrixTrait::new(rhs_len, 1_u32, rhs);
        let lhs_score = calculate_gini(@lhs_matrix);
        let rhs_score = calculate_gini(@rhs_matrix);
        let avg_score = (lhs_score + rhs_score) / 2;

        if avg_score < scores.clone() {
            best_split_value = *data_span.at(i).mag;
            scores = @avg_score;
        }

        i += 1;
    };

    BestSplit { score: scores.clone(), bestsplit: best_split_value }
}

