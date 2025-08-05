#!/usr/bin/env python3
"""
Simple test script to verify Claude API is working in the .venv
"""

import os
from anthropic import Anthropic

def test_claude_connection():
    """Test basic Claude API connection"""
    try:
        # Initialize the client
        client = Anthropic()
        
        # Test with a simple message
        message = client.messages.create(
            model="claude-3-5-sonnet-20241022",
            max_tokens=100,
            messages=[
                {
                    "role": "user",
                    "content": "Hello! Please respond with 'Claude is working in the .venv!'"
                }
            ]
        )
        
        print("✅ Claude API is working!")
        print(f"Response: {message.content[0].text}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        print("\nTo use Claude API, you need to:")
        print("1. Get an API key from https://console.anthropic.com/")
        print("2. Set the ANTHROPIC_API_KEY environment variable:")
        print("   export ANTHROPIC_API_KEY='your-api-key-here'")

if __name__ == "__main__":
    test_claude_connection() 