# Testing Guide

This document outlines testing practices and guidelines for the eBPF for Windows Sample Program project.

## Overview

Testing is crucial for ensuring that sample programs work correctly and demonstrate proper eBPF usage patterns. All sample programs should include appropriate tests and validation procedures.

## Testing Requirements

### Sample Program Testing

Each sample program should include:

1. **Basic functionality tests** - Verify the program loads and executes correctly
2. **Input validation tests** - Test with various inputs and edge cases  
3. **Error handling tests** - Verify proper error handling and cleanup
4. **Documentation validation** - Ensure examples in documentation work as described

### Test Structure

Organize tests in a `tests/` directory within each sample program folder:

```
sample-program/
├── src/
│   ├── program.c
│   └── user_app.c
├── tests/
│   ├── test_basic.c
│   ├── test_edge_cases.c
│   └── validate_output.ps1
└── README.md
```

## Test Types

### Unit Tests

For user-space applications, use standard C testing frameworks or simple assertion-based tests:

```c
// Example unit test
void test_map_operations() {
    // Test map creation, insertion, lookup, deletion
    assert(create_test_map() == 0);
    assert(insert_test_data() == 0);
    assert(lookup_test_data() == 0);
    assert(cleanup_test_map() == 0);
}
```

### Integration Tests

Test the complete sample program workflow:

```powershell
# Example integration test script
$program = "sample_program.exe"
$result = & $program --test-mode
if ($LASTEXITCODE -ne 0) {
    Write-Error "Sample program failed"
    exit 1
}
```

### Load Tests

Verify eBPF program loading and attachment:

```c
// Test eBPF program loading
int test_program_load() {
    int prog_fd = load_ebpf_program("program.o");
    if (prog_fd < 0) {
        return -1;
    }
    
    // Test attachment
    int result = attach_program(prog_fd);
    
    // Cleanup
    close(prog_fd);
    return result;
}
```

## Test Automation

### Build Integration

Include test compilation in build scripts:

```xml
<!-- Example MSBuild target -->
<Target Name="BuildTests" DependsOnTargets="Build">
  <ItemGroup>
    <TestSources Include="tests\*.c" />
  </ItemGroup>
  <ClCompile Sources="@(TestSources)" />
</Target>
```

### Continuous Testing

For automated testing:

1. Create test scripts that can run unattended
2. Use exit codes to indicate success/failure  
3. Capture and log test output
4. Clean up resources after tests

## Test Data and Fixtures

### Test Data Management

- Use small, representative test data sets
- Include both valid and invalid test cases
- Document expected outputs and behaviors
- Store test data in `tests/data/` subdirectories

### Resource Cleanup

Always clean up test resources:

```c
void cleanup_test_resources() {
    // Detach eBPF programs
    detach_all_programs();
    
    // Clean up maps
    cleanup_test_maps();
    
    // Free allocated memory
    free_test_data();
}
```

## Platform-Specific Testing

### Windows Requirements

- Test on supported Windows versions (Windows 10 1909+, Server 2019+)
- Verify administrator privilege requirements
- Test with Windows Defender and other security software

### eBPF Runtime Testing

- Test with current eBPF for Windows runtime versions
- Verify compatibility with different eBPF program types
- Test map types and helper function usage

## Performance Testing

### Basic Performance Validation

Include basic performance checks:

```c
// Example performance test
void test_performance() {
    clock_t start = clock();
    
    // Run sample program operations
    run_sample_operations();
    
    clock_t end = clock();
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Verify reasonable performance
    assert(time_taken < MAX_EXPECTED_TIME);
}
```

### Memory Usage

Monitor memory usage in tests:

```c
// Check for memory leaks
void test_memory_usage() {
    size_t initial_memory = get_memory_usage();
    
    // Run operations
    run_sample_operations();
    cleanup_resources();
    
    size_t final_memory = get_memory_usage();
    
    // Verify no significant memory leaks
    assert(final_memory <= initial_memory + ACCEPTABLE_LEAK_SIZE);
}
```

## Error Testing

### Error Conditions

Test common error scenarios:

- Invalid program files
- Missing dependencies
- Permission errors
- Resource exhaustion
- Network connectivity issues (if applicable)

### Error Handling Validation

```c
// Test error handling
void test_error_handling() {
    // Test with invalid program
    int result = load_ebpf_program("nonexistent.o");
    assert(result < 0);
    
    // Test with invalid parameters
    result = attach_program(-1);
    assert(result < 0);
}
```

## Test Documentation

### Test Case Documentation

Document each test case:

```c
/**
 * @brief Test basic packet filtering functionality
 * @details Loads a packet filter program and verifies it correctly
 *          filters packets based on specified criteria.
 * 
 * Test steps:
 * 1. Load packet filter program
 * 2. Attach to network interface
 * 3. Send test packets
 * 4. Verify filtering results
 * 5. Clean up resources
 */
void test_packet_filtering() {
    // Test implementation
}
```

### Test Results

Document expected test results:

- Normal execution outputs
- Error messages and codes
- Performance benchmarks
- Resource usage patterns

## Best Practices

### Test Development

- Write tests as you develop sample programs
- Keep tests simple and focused
- Use descriptive test names and comments
- Test both success and failure paths

### Test Maintenance

- Update tests when sample programs change
- Remove obsolete tests
- Keep test dependencies minimal
- Regularly run full test suites

### Debugging Tests

- Use verbose output modes for debugging
- Log intermediate test results
- Provide clear failure messages
- Include reproduction steps in bug reports

## Troubleshooting

### Common Test Issues

1. **Permission errors** - Ensure tests run with appropriate privileges
2. **Resource conflicts** - Clean up between test runs
3. **Timing issues** - Add appropriate delays for async operations
4. **Environment dependencies** - Document required environment setup

### Test Environment Setup

Ensure consistent test environments:

```powershell
# Example environment setup script
# Install required dependencies
# Set environment variables
# Configure test data
# Verify eBPF runtime
```

## Contributing Tests

When contributing new tests:

1. Follow the project's testing conventions
2. Include test documentation
3. Verify tests pass in clean environments
4. Add tests for new functionality
5. Update testing documentation as needed

For questions about testing, create an issue or refer to the main project documentation.