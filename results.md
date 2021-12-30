# Task 0
With basic email validation
## Quantitative results
Time taken without co-pilot: ~100 seconds
Time taken with co-pilot: ~20 seconds

## Qualitative results
### Code quality
#### Without co-pilot
- some contestants forget to wrap the file operation in a with block
#### With co-pilot
- nothing mentionable

### Verbal feedback from co-pilot users
- "hadn't excepted that AI is able to accomplish this impressive task"
- "these toy examples are too easy, i'm not that stunned"

# Task 1
tbd

# Task 2
## Quantitative results
Time taken without co-pilot: ~210 seconds
Time taken with co-pilot: ~200 seconds

## Qualitative results
### Verbal feedback from co-pilot users
- "not a big improvement, using copy-paste would leed me in the used time to the same result"
- "expected a little bit more"




# Task 3
## Quantitative results
Time taken without co-pilot: ~300 seconds
Time taken with co-pilot: ~200 seconds

### Code quality
#### Without co-pilot
- some contestants put the decode operation in a "catch all" block
#### With co-pilot
-  magic number in "token = auth_header[7:]" better:
```python
BEARER_PREFIX = 'Bearer '
if not auth_header.startswith(BEARER_PREFIX):
    return False
token = auth_header[len(BEARER_PREFIX):]
```

### Verbal feedback from co-pilot users
- "great result, it saved me time to read through the code examples, from co-pilot but it took me a second to use the correct exceptions"

