
"""
This script trains a machine learning model, evaluates it, enhances it with adversarial training, 
compares performance, and saves the final models in ONNX format for platform interoperability.
"""

from data_handler import DataHandler  # Handles data loading and preprocessing
from model_builder import ModelBuilder  # Constructs and compiles the machine learning model
from evaluator import Evaluator  # Evaluates model performance metrics
from progress_bar import ProgressBar  # Custom progress bar for tracking training
from onnx_saver import OnnxModelSaver  # Saves models in ONNX format
from adversarial_trainer import AdversarialTrainer  # Enhances model robustness with adversarial training
from evaluator2 import Evaluator2

def main():
    """
    Main function to set up parameters, build and train a model, 
    evaluate the model's performance, apply adversarial training, 
    and save both the base and adversarially trained models.
    """
    
    # Parameters
    filepath = "Training_Data.csv"  # Path to the dataset file
    target_column = "target"  # Column name for the labels in the dataset
    input_size = 7  # Number of input features for the model
    batch_size = 100  # Batch size for training
    epochs = 1000  # Number of epochs for training
    epsilon = 0.01  # Epsilon for adversarial robustness (small perturbations)

    # Step 1: Data Handling
    data_handler = DataHandler(filepath)  # Initialises the data handler with the file path
    data_handler.load_data()  # Loads data from the specified file
    train_dataset, test_dataset, X_test, y_test = data_handler.prepare_datasets(
        target_column=target_column, batch_size=batch_size
    )  # Prepares training and test datasets, along with test data for evaluation

    # Step 2: Model Building
    progress_bar = ProgressBar()  # Custom progress bar for training
    model_builder = ModelBuilder(input_size=input_size)  # Initialises model builder with input size
    model = model_builder.build_model()  # Constructs the model structure
    model_builder.compile_model()  # Compiles the model with specified loss and optimizer
    model2 = model
    history = model_builder.train_model(
        train_dataset,
        test_dataset,
        epochs=epochs,
        verbose=0,  # Suppresses Keras verbose output
        callbacks=[progress_bar],  # Integrates custom progress bar
    )  # Trains the model with training and validation data

    # Step 3: Evaluate the Base Model
    evaluator = Evaluator()  # Initialises evaluator for performance metrics
    print("\nEvaluating the base model:")
    base_metrics = evaluator.evaluate(history, model, X_test, y_test)  # Evaluates base model
    
    saver = OnnxModelSaver()  # Initialises the model saver
    saver.save(model, "base_model")  # Saves base model as ONNX

    # Step 4: Adversarial Training for Robustness
    print("\nStarting adversarial training with epsilon-ball robustness...")
# %%
    adversarial_trainer = AdversarialTrainer(model2, epsilon=epsilon)  # Sets up adversarial trainer
    adversarial_model, history2= adversarial_trainer.train_with_adversarial_examples(
        train_dataset, epochs=epochs, callbacks=[progress_bar]
    )  # Trains the model with adversarial examples for robustness

    # %%
    # Step 5: Evaluate the Adversarially Trained Model
    print("\nEvaluating the adversarially trained model:")
    evaluator2 = Evaluator2()
    
    adversarial_metrics = evaluator2.evaluate(history2, adversarial_model, X_test, y_test)  # Evaluates adversarial model

    # Print Metrics Comparison
    print("\n--- Comparison of Base Model and Adversarial Model ---")
    print("Base Model Metrics:", base_metrics)  # Outputs base model metrics
    print("Adversarial Model Metrics:", adversarial_metrics)  # Outputs adversarial model metrics

    # Save Models in ONNX Format

    saver.save(adversarial_model, "adversarial_model")  # Saves adversarially trained model as ONNX

    return base_metrics, adversarial_metrics  # Returns metrics for further analysis


# Entry point of the script
if __name__ == "__main__":
    main()
