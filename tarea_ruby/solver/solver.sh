for solution in $(pwd)/solutions/*; do
    foldername="${solution//$(pwd)\/solutions\/}"
    echo "Running code from '${foldername}'"

    # Initial cleanup
    echo "# Initial cleanup"
    rm -rf "$solution"/tests
    rm -rf "$solution"/outputs

    # Create folder for outputs
    echo "# Creating output folders"
    mkdir -p "$solution"/outputs/expected
    mkdir -p "$solution"/outputs/tested

    # Move assets to folder
    echo "# Getting assets"
    cp -r tests "$solution"/tests
    cp tests/outputs/* "$solution"/outputs/expected

    # Execute main script
    # Small dataset
    ruby "$solution"/main.rb "$solution"/tests/small-dataset "$solution"/tests/instructions.txt "$solution"/outputs/tested/small-dataset-logs.txt > /dev/null 2>&1
    if diff "$solution"/outputs/tested/small-dataset-logs.txt "$solution"/outputs/expected/small-dataset-logs.txt > /dev/null 2>&1; then
        echo "### Code from '${foldername}' against small dataset: SUCCESS"
    else
        echo "### Code from '${foldername}' against small dataset: FAILURE"
    fi
    # Medium dataset
    ruby "$solution"/main.rb "$solution"/tests/medium-dataset "$solution"/tests/instructions.txt "$solution"/outputs/tested/medium-dataset-logs.txt > /dev/null 2>&1
    if diff "$solution"/outputs/tested/medium-dataset-logs.txt "$solution"/outputs/expected/medium-dataset-logs.txt > /dev/null 2>&1; then
        echo "### Code from '${foldername}' against medium dataset: SUCCESS"
    else
        echo "### Code from '${foldername}' against medium dataset: FAILURE"
    fi
    # Large dataset
    ruby "$solution"/main.rb "$solution"/tests/large-dataset "$solution"/tests/instructions.txt "$solution"/outputs/tested/large-dataset-logs.txt > /dev/null 2>&1
    if diff "$solution"/outputs/tested/large-dataset-logs.txt "$solution"/outputs/expected/large-dataset-logs.txt > /dev/null 2>&1; then
        echo "### Code from '${foldername}' against large dataset: SUCCESS"
    else
        echo "### Code from '${foldername}' against large dataset: FAILURE"
    fi

    # Final cleanup
    echo "# Final cleanup"
    rm -rf "$solution"/tests

    echo ""
done
