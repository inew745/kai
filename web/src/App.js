import React, { useState, useRef, useEffect } from 'react';
import './App.css';

const HF_API_URL = 'https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium';
const HF_API_TOKEN = process.env.REACT_APP_HF_TOKEN || '';

const KAI_GREETING = "שלום! אני Kai, העוזר החכם שלך. איך אני יכול לעזור לך היום?";

async function queryKai(userMessage, conversationHistory) {
  const payload = {
    inputs: {
      past_user_inputs: conversationHistory
        .filter((m) => m.role === 'user')
        .map((m) => m.text),
      generated_responses: conversationHistory
        .filter((m) => m.role === 'bot')
        .map((m) => m.text),
      text: userMessage,
    },
    parameters: {
      max_length: 200,
      temperature: 0.7,
      repetition_penalty: 1.3,
    },
  };

  const headers = { 'Content-Type': 'application/json' };
  if (HF_API_TOKEN) headers['Authorization'] = `Bearer ${HF_API_TOKEN}`;

  const response = await fetch(HF_API_URL, {
    method: 'POST',
    headers,
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    if (response.status === 503) {
      throw new Error('המודל נטען, נסה שוב בעוד מספר שניות...');
    }
    throw new Error(err.error || `שגיאה ${response.status}`);
  }

  const data = await response.json();
  return data.generated_text || "אני Kai. לא הצלחתי להבין, תוכל לנסח מחדש?";
}

function TypingIndicator() {
  return (
    <div className="message bot-message typing">
      <div className="avatar kai-avatar">K</div>
      <div className="bubble">
        <span className="dot" />
        <span className="dot" />
        <span className="dot" />
      </div>
    </div>
  );
}

function Message({ msg }) {
  return (
    <div className={`message ${msg.role === 'user' ? 'user-message' : 'bot-message'}`}>
      {msg.role === 'bot' && <div className="avatar kai-avatar">K</div>}
      <div className="bubble">
        <p>{msg.text}</p>
        <span className="timestamp">{msg.time}</span>
      </div>
      {msg.role === 'user' && <div className="avatar user-avatar">א</div>}
    </div>
  );
}

export default function App() {
  const [messages, setMessages] = useState([
    { role: 'bot', text: KAI_GREETING, time: now() },
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const bottomRef = useRef(null);
  const inputRef = useRef(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, loading]);

  async function sendMessage() {
    const text = input.trim();
    if (!text || loading) return;

    setError('');
    setInput('');
    const userMsg = { role: 'user', text, time: now() };
    setMessages((prev) => [...prev, userMsg]);
    setLoading(true);

    try {
      const history = messages;
      const reply = await queryKai(text, history);
      setMessages((prev) => [...prev, { role: 'bot', text: reply, time: now() }]);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
      inputRef.current?.focus();
    }
  }

  function handleKey(e) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  }

  return (
    <div className="app">
      {/* Header */}
      <header className="header">
        <div className="header-left">
          <div className="logo">K</div>
          <div>
            <h1 className="brand">Kai</h1>
            <span className="status online">● מחובר</span>
          </div>
        </div>
        <a
          className="download-btn"
          href="/kai.apk"
          download="Kai.apk"
        >
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/>
            <line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
          הורד APK לאנדרואיד
        </a>
      </header>

      {/* Chat area */}
      <main className="chat-area">
        <div className="messages">
          {messages.map((msg, i) => (
            <Message key={i} msg={msg} />
          ))}
          {loading && <TypingIndicator />}
          {error && (
            <div className="error-banner">
              <span>⚠ {error}</span>
              <button onClick={() => setError('')}>✕</button>
            </div>
          )}
          <div ref={bottomRef} />
        </div>
      </main>

      {/* Input */}
      <footer className="input-area">
        <div className="input-wrapper">
          <textarea
            ref={inputRef}
            className="chat-input"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={handleKey}
            placeholder="כתוב הודעה ל-Kai..."
            rows={1}
            disabled={loading}
          />
          <button
            className={`send-btn ${loading ? 'loading' : ''}`}
            onClick={sendMessage}
            disabled={loading || !input.trim()}
            aria-label="שלח"
          >
            {loading ? (
              <div className="spinner" />
            ) : (
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <line x1="22" y1="2" x2="11" y2="13"/>
                <polygon points="22 2 15 22 11 13 2 9 22 2"/>
              </svg>
            )}
          </button>
        </div>
        <p className="hint">Enter לשליחה • Shift+Enter לשורה חדשה</p>
      </footer>
    </div>
  );
}

function now() {
  return new Date().toLocaleTimeString('he-IL', { hour: '2-digit', minute: '2-digit' });
}
