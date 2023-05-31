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

trait DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree;
    fn class_count(self: @DecisionTree) -> Felt252Dict<felt252>;
    fn calculate_gini(self: @DecisionTree) -> u64;
    fn find_split(self: @DecisionTree) -> u32;
}

impl DTImpl of DTTrait {
    fn new(X: Matrix, y: Matrix) -> DecisionTree {
        create_new(X, y)
    }

    fn class_count(self: @DecisionTree) -> Felt252Dict<felt252> {
        let mut dict: Felt252Dict<felt252> = Felt252DictTrait::new();
        let data_len = self.y.len();

        let mut counter: usize = 0;
        loop {
            if counter == data_len {
                break ();
            }
            let mut data = self.y.get(counter, 0_u32);
            let key: felt252 = data.mag.into();
            let val = dict.get(key);
            dict.insert(key, val + 1);
            counter += 1;
        };
        dict
    }

    fn calculate_gini(self: @DecisionTree) -> u64 {
        let data_len = self.y.len();
        let mut counts = self.class_count();
        let mut impurity = 100_u64;
        let mut counter: felt252 = 0;
        let mut array = unique_array(self);
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

        impurity
    }

    fn find_split(self: @DecisionTree) -> u32 {
        let X = self.X;
        let data = X.get_column(0);

        let arr = get_unique_values(data);
        let arr_len = arr.len();
        arr_len.print();
        arr_len
    }
}

fn create_new(X: Matrix, y: Matrix) -> DecisionTree {
    DecisionTree { X: X, y: y, score: BoundedInt::max() }
}


fn unique_array(value: @DecisionTree) -> Array<felt252> {
    let mut counter: felt252 = 0;
    let data_len = value.y.len();
    let mut a = ArrayTrait::new();
    let mut counts = value.class_count();

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

fn get_unique_values(value: Array<i64>) -> Array<u32> {
    let mut unique_values = ArrayTrait::<u32>::new();
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
            let value_i: u32 = value_clone.at(i).clone().mag.try_into().unwrap();
            let values_j = unique_values_clone.at(j).clone();

            if value_i == values_j {
                is_unique = false;
                break ();
            }
            j += 1;
        };
        let value_i: u32 = (*value.at(i)).mag.try_into().unwrap();

        if is_unique == true {
            unique_values.append(value_i);
        }

        i += 1;
    };
    unique_values
}

